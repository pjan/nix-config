{ pkgs, lib, ... }:

let
  # Small C binary that samples CPU via host_processor_info() twice (100ms apart)
  # and outputs the usage percentage. Avoids the ~2s overhead of `top -l 2`.
  cpu-src = pkgs.writeText "sketchybar-cpu-usage.c" ''
    #include <stdio.h>
    #include <stdlib.h>
    #include <mach/mach.h>
    #include <unistd.h>

    typedef struct { natural_t user, sys, idle, nice; } Ticks;

    static Ticks aggregate(natural_t n, processor_cpu_load_info_t load) {
      Ticks t = {0, 0, 0, 0};
      for (natural_t i = 0; i < n; i++) {
        t.user += load[i].cpu_ticks[CPU_STATE_USER];
        t.sys  += load[i].cpu_ticks[CPU_STATE_SYSTEM];
        t.idle += load[i].cpu_ticks[CPU_STATE_IDLE];
        t.nice += load[i].cpu_ticks[CPU_STATE_NICE];
      }
      return t;
    }

    int main(void) {
      natural_t cpu_count;
      processor_cpu_load_info_t load1, load2;
      mach_msg_type_number_t count1, count2;

      if (host_processor_info(mach_host_self(), PROCESSOR_CPU_LOAD_INFO,
                              &cpu_count, (processor_info_array_t *)&load1, &count1)
          != KERN_SUCCESS) { puts("0"); return 1; }

      usleep(100000); /* 100 ms */

      if (host_processor_info(mach_host_self(), PROCESSOR_CPU_LOAD_INFO,
                              &cpu_count, (processor_info_array_t *)&load2, &count2)
          != KERN_SUCCESS) {
        vm_deallocate(mach_task_self(), (vm_address_t)load1, count1 * sizeof(natural_t));
        puts("0"); return 1;
      }

      Ticks a = aggregate(cpu_count, load1);
      Ticks b = aggregate(cpu_count, load2);

      vm_deallocate(mach_task_self(), (vm_address_t)load1, count1 * sizeof(natural_t));
      vm_deallocate(mach_task_self(), (vm_address_t)load2, count2 * sizeof(natural_t));

      long total  = ((long)b.user - a.user) + ((long)b.sys  - a.sys)
                  + ((long)b.idle - a.idle) + ((long)b.nice - a.nice);
      long active = ((long)b.user - a.user) + ((long)b.sys  - a.sys)
                  + ((long)b.nice - a.nice);

      printf("%d\n", total > 0 ? (int)((double)active / total * 100.0 + 0.5) : 0);
      return 0;
    }
  '';

  sketchybar-cpu-usage = pkgs.stdenv.mkDerivation {
    name = "sketchybar-cpu-usage";
    src = cpu-src;
    phases = [
      "buildPhase"
      "installPhase"
    ];
    buildPhase = "cc -O2 -o sketchybar-cpu-usage $src";
    installPhase = ''
      mkdir -p $out/bin
      install -m 755 sketchybar-cpu-usage $out/bin/
    '';
  };

  # Objective-C binary that queries WiFi RSSI via CoreWLAN and renders the
  # native macOS WiFi SF Symbol (with variableValue + hierarchicalColor) to PNG.
  # RSSI is not gated by Location Services (only SSID/BSSID are).
  # Usage: sketchybar-wifi-icon <output.png> [hex_color] [point_size]
  # Stdout: "<rssi>" (e.g. "-53") when connected, "off" when disconnected.
  wifi-src = pkgs.writeText "sketchybar-wifi-icon.m" ''
    #import <Foundation/Foundation.h>
    #import <AppKit/AppKit.h>
    #import <CoreWLAN/CoreWLAN.h>
    #include <stdio.h>

    int main(int argc, const char *argv[]) {
      @autoreleasepool {
        [NSApplication sharedApplication];

        const char *outPath = "/tmp/sketchybar-wifi.png";
        unsigned int hex = 0xFFFFFF;
        CGFloat pointSize = 16.0;
        CGFloat scale = 2.0;

        if (argc > 1) outPath = argv[1];
        if (argc > 2) sscanf(argv[2], "%x", &hex);
        if (argc > 3) pointSize = atof(argv[3]);

        NSColor *color = [NSColor colorWithSRGBRed:((hex >> 16) & 0xFF) / 255.0
                                             green:((hex >> 8) & 0xFF) / 255.0
                                              blue:(hex & 0xFF) / 255.0
                                             alpha:1.0];

        CWWiFiClient *client = [CWWiFiClient sharedWiFiClient];
        CWInterface  *iface  = [client interface];

        NSString *symName;
        double varValue;

        if (!iface || !iface.powerOn || [iface rssiValue] == 0) {
          symName  = @"wifi.slash";
          varValue = 0.0;
          puts("off");
        } else {
          NSInteger rssi = [iface rssiValue];
          symName  = @"wifi";
          /* Discrete breakpoints matching macOS native WiFi icon */
          if      (rssi >= -70) varValue = 1.0;
          else if (rssi >= -78) varValue = 0.66;
          else if (rssi >= -88) varValue = 0.33;
          else                  varValue = 0.0;
          printf("%ld\n", (long)rssi);
        }

        NSImage *sym = [NSImage imageWithSystemSymbolName:symName
                                           variableValue:varValue
                                 accessibilityDescription:nil];
        if (!sym) return 1;

        NSImageSymbolConfiguration *conf =
          [[NSImageSymbolConfiguration configurationWithHierarchicalColor:color]
           configurationByApplyingConfiguration:
              [NSImageSymbolConfiguration configurationWithPointSize:pointSize
                                                              weight:NSFontWeightRegular]];
        NSImage *img = [sym imageWithSymbolConfiguration:conf];
        if (!img) img = sym;

        NSSize sz = [img size];
        NSInteger pw = (NSInteger)ceil(sz.width * scale);
        NSInteger ph = (NSInteger)ceil(sz.height * scale);

        NSBitmapImageRep *rep = [[NSBitmapImageRep alloc]
          initWithBitmapDataPlanes:NULL pixelsWide:pw pixelsHigh:ph
          bitsPerSample:8 samplesPerPixel:4 hasAlpha:YES isPlanar:NO
          colorSpaceName:NSDeviceRGBColorSpace bytesPerRow:0 bitsPerPixel:0];
        [rep setSize:sz];

        [NSGraphicsContext saveGraphicsState];
        [NSGraphicsContext setCurrentContext:
          [NSGraphicsContext graphicsContextWithBitmapImageRep:rep]];
        [img drawInRect:NSMakeRect(0, 0, sz.width, sz.height)
               fromRect:NSZeroRect
              operation:NSCompositingOperationSourceOver
               fraction:1.0
         respectFlipped:YES hints:nil];
        [NSGraphicsContext restoreGraphicsState];

        NSData *png = [rep representationUsingType:NSBitmapImageFileTypePNG
                                        properties:@{}];
        [png writeToFile:[NSString stringWithUTF8String:outPath] atomically:YES];

        return 0;
      }
    }
  '';

  # Generic SF Symbol renderer. Renders any SF Symbol to PNG with
  # variableValue and hierarchicalColor, matching macOS native icon style.
  # Usage: sketchybar-sf-icon <output.png> <symbol_name> <variable_value> [hex_color] [point_size]
  sf-icon-src = pkgs.writeText "sketchybar-sf-icon.m" ''
    #import <Foundation/Foundation.h>
    #import <AppKit/AppKit.h>
    #include <stdio.h>

    int main(int argc, const char *argv[]) {
      @autoreleasepool {
        [NSApplication sharedApplication];

        if (argc < 4) {
          fprintf(stderr, "usage: sketchybar-sf-icon <out.png> <symbol> <varValue> [hex] [ptSize]\n");
          return 1;
        }

        const char *outPath = argv[1];
        NSString *symName   = [NSString stringWithUTF8String:argv[2]];
        double varValue     = atof(argv[3]);
        unsigned int hex    = argc > 4 ? 0 : 0xFFFFFF;
        CGFloat pointSize   = argc > 5 ? atof(argv[5]) : 14.0;
        CGFloat scale       = 2.0;

        if (argc > 4) sscanf(argv[4], "%x", &hex);

        NSColor *color = [NSColor colorWithSRGBRed:((hex >> 16) & 0xFF) / 255.0
                                             green:((hex >> 8) & 0xFF) / 255.0
                                              blue:(hex & 0xFF) / 255.0
                                             alpha:1.0];

        NSImage *sym = [NSImage imageWithSystemSymbolName:symName
                                           variableValue:varValue
                                 accessibilityDescription:nil];
        if (!sym) { fprintf(stderr, "unknown symbol: %s\n", argv[2]); return 1; }

        NSImageSymbolConfiguration *conf =
          [[NSImageSymbolConfiguration configurationWithHierarchicalColor:color]
           configurationByApplyingConfiguration:
              [NSImageSymbolConfiguration configurationWithPointSize:pointSize
                                                              weight:NSFontWeightRegular]];
        NSImage *img = [sym imageWithSymbolConfiguration:conf];
        if (!img) img = sym;

        NSSize sz = [img size];
        NSInteger pw = (NSInteger)ceil(sz.width * scale);
        NSInteger ph = (NSInteger)ceil(sz.height * scale);

        NSBitmapImageRep *rep = [[NSBitmapImageRep alloc]
          initWithBitmapDataPlanes:NULL pixelsWide:pw pixelsHigh:ph
          bitsPerSample:8 samplesPerPixel:4 hasAlpha:YES isPlanar:NO
          colorSpaceName:NSDeviceRGBColorSpace bytesPerRow:0 bitsPerPixel:0];
        [rep setSize:sz];

        [NSGraphicsContext saveGraphicsState];
        [NSGraphicsContext setCurrentContext:
          [NSGraphicsContext graphicsContextWithBitmapImageRep:rep]];
        [img drawInRect:NSMakeRect(0, 0, sz.width, sz.height)
               fromRect:NSZeroRect
              operation:NSCompositingOperationSourceOver
               fraction:1.0
         respectFlipped:YES hints:nil];
        [NSGraphicsContext restoreGraphicsState];

        NSData *png = [rep representationUsingType:NSBitmapImageFileTypePNG
                                        properties:@{}];
        [png writeToFile:[NSString stringWithUTF8String:outPath] atomically:YES];

        return 0;
      }
    }
  '';

  sketchybar-sf-icon = pkgs.stdenv.mkDerivation {
    name = "sketchybar-sf-icon";
    src = sf-icon-src;
    phases = [
      "buildPhase"
      "installPhase"
    ];
    buildPhase = ''
      cc -O2 -framework Foundation -framework AppKit \
        -o sketchybar-sf-icon $src
    '';
    installPhase = ''
      mkdir -p $out/bin
      install -m 755 sketchybar-sf-icon $out/bin/
    '';
  };

  sketchybar-wifi-icon = pkgs.stdenv.mkDerivation {
    name = "sketchybar-wifi-icon";
    src = wifi-src;
    phases = [
      "buildPhase"
      "installPhase"
    ];
    buildPhase = ''
      cc -O2 -framework Foundation -framework AppKit -framework CoreWLAN \
        -o sketchybar-wifi-icon $src
    '';
    installPhase = ''
      mkdir -p $out/bin
      install -m 755 sketchybar-wifi-icon $out/bin/
    '';
  };
in

{

  home.packages = with pkgs; [
    sbarlua
    sketchybar-app-font
    sketchybar-cpu-usage
    sketchybar-wifi-icon
    sketchybar-sf-icon
  ];

  xdg.configFile."sketchybar".source = ../sketchybar;

  home.activation.restartSketchybar = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    /bin/launchctl kickstart -k gui/$(id -u)/org.nixos.sketchybar 2>/dev/null || true
  '';

}
