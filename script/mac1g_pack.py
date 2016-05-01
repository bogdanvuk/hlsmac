
from mac1g_receive import build as receive_synth
from mac1g_transmit import build as transmit_synth
from mac1g_axi_lite import build as axi_lite_synth
from pymake.build import Build
from pymake.builds.fileset import FilesetBuild, FileCopyBuild, FileBuild
import os
from pymake.utils import Fileset
import itertools
from pymake.builds.vivado import VivadoInteractInst, VivadoProject,\
    VivadoIpProject, VivadoIpProjectBuild
import time

synths = Build(receive_synth, transmit_synth, axi_lite_synth, FilesetBuild(match = ['$SRCDIR/module/mac1g_top/hdl/*.vhd']))
synths.srcs_setup['args'].target = ['synth', 'synth', 'synth', 'all']
 
class FilesetCombinedCopy(FileCopyBuild):
    def build_postproc_src(self, name, res, collection, key):
        return Fileset(list(itertools.chain(*res)), list_timestamp=min([f.list_timestamp for f in res]))
 
hdl_fileset = FilesetCombinedCopy(synths, FileBuild('$BUILDDIR/ip/mac1g/hdl'))
# i = VivadoInteractInst()
# i.open()
# resp = i.cmd('get_projects')

#hdl = FilesetBuild(match=[os.path.join('..', '..', 'build', 'ip', 'mac1g', 'hdl/*.vhd')]).build()
prj = VivadoIpProjectBuild(name     = 'mac1g_pack', 
                           prjdir   = FileBuild('$BUILDDIR/mac1g_pack'), 
                           ipdir    = FileBuild('$BUILDDIR/ip/mac1g'),
                           sources  = {'sources_1': hdl_fileset},
                           env      = dict(BUILDNAME="mac1g_pack", BUILDDIR='../../build', SRCDIR='../'))
#prj.open()
# prj.configure()
# prj.close()
prj.build()
pass
