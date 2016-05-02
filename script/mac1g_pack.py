
# from mac1g_receive import top as receive_synth
# from mac1g_transmit import top as transmit_synth
# from mac1g_axi_lite import top as axi_lite_synth
from synth import top as synth_top
from pymake.build import Build
from pymake.builds.fileset import FilesetBuild, FileCopyBuild, FileBuild
import os
from pymake.utils import Fileset
import itertools
from pymake.builds.vivado import VivadoInteractInst, VivadoProject,\
    VivadoIpProject, VivadoIpProjectBuild, VivadoIpBuild, IpInstBuild,\
    VivadoProjectBuild
import time

# synths = Build(receive_synth, transmit_synth, axi_lite_synth, FilesetBuild(match = ['$SRCDIR/module/mac1g_top/hdl/*.vhd']))
synths = Build(synth_top, synth_top, synth_top, FilesetBuild(match = ['$SRCDIR/module/mac1g_top/hdl/*.vhd']))
synths.srcs_setup['args'].target = ['mac1g_receive.synth', 'mac1g_transmit.synth', 'mac1g_axi_lite.synth', 'all']
 
class FilesetCombinedCopy(FileCopyBuild):
    def build_postproc_src(self, name, res, collection, key):
        return Fileset(list(itertools.chain(*res)), list_timestamp=min([f.list_timestamp for f in res]))
 
hdl_fileset = FilesetCombinedCopy(synths, FileBuild('$BUILDDIR/ip/mac1g/hdl'))
ipprj = VivadoIpProjectBuild(name     = 'ippack',
                           prjdir   = FileBuild(os.path.join('$BUILDDIR', 'mac1g_pack', 'ippack')),
                           ipdir    = FileBuild('$BUILDDIR/ip/mac1g'),
                           sources  = {'sources_1': hdl_fileset},
                           ipconfig = {'vendor' : 'bogdanvuk.org', 'name': 'hlsmac1g', 'library': 'ip', 'display_name': '{HLS 1G MAC}'}, 
                           env      = dict(BUILDNAME="ippack"))

ip = VivadoIpBuild(ipprj=ipprj)
# prjinst = VivadoProjectBuild(name  = 'mac1g_pack_inst',
#                              prjdir   = FileBuild(os.path.join('$BUILDDIR', 'mac1g_pack', 'ipinst')),
#                              ips = [IpInstBuild('hlsmac1g_i', 'bogdanvuk.org:ip:hlsmac1g', ipdir=ip)],
#                              env   = dict(BUILDNAME="mac1g_pack_inst"),
#                              )


top = Build(ippack=ip, 
#             prjinst=prjinst, 
            env      = dict(BUILDDIR='../../build', SRCDIR='../'))

if __name__ == "__main__":
    top.cli_build()
