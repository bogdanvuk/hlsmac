from build_template import HlsSynthBuildFactory
from pymake.build import Build

top = Build(
            mac1g_receive   =HlsSynthBuildFactory('mac1g_receive', 'receive', 
                                                  include=['$SRCDIR/module/crc32/hls', 
                                                           '$SRCDIR/module/mac1g_top/hls']),
            mac1g_transmit  =HlsSynthBuildFactory('mac1g_transmit', 'transmit', 
                                                  include=['$SRCDIR/module/crc32/hls', 
                                                           '$SRCDIR/module/mac1g_top/hls']),
            mac1g_axi_lite  =HlsSynthBuildFactory('axi_lite', 'axi_lite', 
                                                  include=['$SRCDIR/module/mac1g_top/hls', 
                                                           '$SRCDIR/module/mac1g_transmit/hls', 
                                                           '$SRCDIR/module/mac1g_receive/hls'], 
                                                  buildname='mac1g_axi_lite'),
            mac10g_receive   =HlsSynthBuildFactory('mac10g_receive', 'receive', 
                                                  include=['$SRCDIR/module/crc32/hls', 
                                                           '$SRCDIR/module/mac10g_top/hls']),
            mac10g_transmit  =HlsSynthBuildFactory('mac10g_transmit', 'transmit', 
                                                  include=['$SRCDIR/module/crc32/hls', 
                                                           '$SRCDIR/module/mac10g_top/hls']),
            mac10g_axi_lite  =HlsSynthBuildFactory('axi_lite', 'axi_lite', 
                                                  include=['$SRCDIR/module/mac10g_top/hls', 
                                                           '$SRCDIR/module/mac10g_transmit/hls', 
                                                           '$SRCDIR/module/mac10g_receive/hls'], 
                                                  buildname='mac1g_axi_lite')

            )

if __name__ == "__main__":
    top.cli_build()
