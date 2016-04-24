from pymake.builds.fileset import FilesetBuild, FileBuild
from pymake.builds.vivado_hls import VivadoHlsProjectBuild, VivadoHlsSolution,\
    VivadoHlsVhdlSynthBuild
from pymake.build import Build, SrcConf
from collections import OrderedDict
import os

class SynthBuildCollection(Build):
    srcs_setup = OrderedDict([
                              ('collection',       SrcConf('dict')),
                              ])
    
    def __init__(self, collection):
        super().__init__(collection=collection)
    
    def build_src_collection_item(self, src, key):
        return self.build_src_def('_'.join(['collection', str(key)]), src[key], os.path.join(self.builddir, key))

def VivadoHlsSynthBuildFactory(module_name):
    prj = VivadoHlsProjectBuild(prj          = FileBuild('$BUILDDIR'),
                                 config       = {'top': module_name},
                                 fileset      = FilesetBuild(match=['$SRCDIR/{}/*'.format(module_name),
                                                                    '$SRCDIR/fcs/*'], 
                                                             ignore=['$SRCDIR/*/tb/*']),
                                 include      = FilesetBuild(['$SRCDIR/include']),
                                 tb_fileset   = FilesetBuild(match=['$SRCDIR/{}/tb/*.cpp'.format(module_name)]),
                                 solutions    = [VivadoHlsSolution(clock='-period 40 -name default', 
                                                                   config={'rtl': '-reset all -reset_level high'})]
                  )
    return VivadoHlsVhdlSynthBuild(prj)

b = SynthBuildCollection({name:VivadoHlsSynthBuildFactory(name) for name in ['axi_lite', 'receive', 'transmit']})
prjs = b.build('hlsmac', builddir='../build', srcdir='../src')
pass
# prj = VivadoHlsProjectBuildFactory('axi_lite')    
# b = VivadoHlsVhdlSynthBuild(prj)
# inst = b.build('axi_lite', builddir='../build/axi_lite', srcdir='../src')



