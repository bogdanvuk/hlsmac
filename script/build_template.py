from pymake.builds.fileset import FileBuild, FilesetBuild
from pymake.builds.vivado_hls import VivadoHlsProjectBuild, VivadoHlsSolution,\
    VivadoHlsVhdlSynthBuild
from pymake.build import Build
import os

def HlsSynthBuildFactory(module, top_func, include, buildname=None):
    if buildname is None:
        buildname = module
    
    prj = VivadoHlsProjectBuild(prj          = FileBuild('$BUILDDIR'),
                                config       = {'top': top_func},
                                fileset      = FilesetBuild(match=[os.path.join('$SRCDIR','module',module,'hls','*')]), 
                                include      = FilesetBuild(include),
                                cflags       = '-DRELEASE',
                                solutions    = [VivadoHlsSolution(config={'rtl': '-reset all -reset_level high'})]
                      )
    synth = VivadoHlsVhdlSynthBuild(prj, env=dict(BUILDDIR=os.path.join('$BUILDDIR', buildname)))
    return Build(synth=synth, env=dict(BUILDNAME=buildname, BUILDDIR='../../build', SRCDIR='../'))
