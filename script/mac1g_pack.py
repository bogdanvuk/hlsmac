
from mac1g_receive import build as receive_synth
from mac1g_transmit import build as transmit_synth
from mac1g_axi_lite import build as axi_lite_synth
from pymake.build import Build
from pymake.builds.fileset import FilesetBuild, FileCopyBuild, FileBuild
import os
from pymake.utils import Fileset
import itertools

synths = Build(receive_synth, transmit_synth, axi_lite_synth)
synths.srcs_setup['args'].target = 'synth'
# fileset_combine = Build(*[FilesetBuild(match=[os.path.join('$BUILDDIR', name, 'solution1', 'syn', 'vhdl', '*.vhd')]) 
#                           for name in ['axi_lite', 'receive', 'transmit']])

class FilesetCombinedCopy(FileCopyBuild):
    def build_postproc_args(self, name, res, collection, key):
        if (collection=='') and (key[1] == 1):
            return Fileset(list(itertools.chain(*res)), list_timestamp=min([f.list_timestamp for f in res]))
        
        return res

fileset_combined_copy = FilesetCombinedCopy((FileBuild(os.path.join('..', '..', 'build', 'ip', 'mac1g', 'hdl')), synths),
                                            env=dict(BUILDNAME="mac1g_pack", BUILDDIR='../../build', SRCDIR='../'))
fileset_combined_copy.build()
# b = FileCopyBuild((FileBuild(os.path.join('$BUILDDIR', 'ip', 'hdl')), b))
