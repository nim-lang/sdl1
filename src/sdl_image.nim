#
#
#            Nim's Runtime Library
#        (c) Copyright 2015 Andreas Rumpf
#
#    See the file "LICENSE.txt", included in this
#    distribution, for details about the copyright.
#

import
  sdl

when defined(windows):
  const
    ImageLibName = "SDL_Image.dll"
elif defined(macosx):
  const
    ImageLibName = "libSDL_image-1.2.0.dylib"
else:
  const
    ImageLibName = "libSDL_image(.so|-1.2.so.0)"
const
  IMAGE_MAJOR_VERSION* = 1
  IMAGE_MINOR_VERSION* = 2
  IMAGE_PATCHLEVEL* = 5

# This macro can be used to fill a version structure with the compile-time
#  version of the SDL_image library.

proc imageVersion*(x: var Version)
  # This function gets the version of the dynamically linked SDL_image library.
  #   it should NOT be used to fill a version structure, instead you should
  #   use the SDL_IMAGE_VERSION() macro.
  #
proc imgLinkedVersion*(): Pversion{.importc: "IMG_Linked_Version",
                                    dynlib: ImageLibName.}
  # Load an image from an SDL data source.
  #   The 'type' may be one of: "BMP", "GIF", "PNG", etc.
  #
  #   If the image format supports a transparent pixel, SDL will set the
  #   colorkey for the surface.  You can enable RLE acceleration on the
  #   surface afterwards by calling:
  #        SDL_SetColorKey(image, SDL_RLEACCEL, image.format.colorkey);
  #

const
  IMG_INIT_JPG* = 0x00000001
  IMG_INIT_PNG* = 0x00000002
  IMG_INIT_TIF* = 0x00000004
  IMG_INIT_WEBP* = 0x00000008

proc imgInit*(flags: cint): int {.cdecl, importc: "IMG_Init",
                                  dynlib: ImageLibName.}
proc imgQuit*() {.cdecl, importc: "IMG_Quit",
                                  dynlib: ImageLibName.}
proc imgLoadTypedRW*(src: PRWops, freesrc: cint, theType: cstring): PSurface{.
    cdecl, importc: "IMG_LoadTyped_RW", dynlib: ImageLibName.}
  # Convenience functions
proc imgLoad*(theFile: cstring): PSurface{.cdecl, importc: "IMG_Load",
    dynlib: ImageLibName.}
proc imgLoadRW*(src: PRWops, freesrc: cint): PSurface{.cdecl,
    importc: "IMG_Load_RW", dynlib: ImageLibName.}
  # Invert the alpha of a surface for use with OpenGL
  #  This function is now a no-op, and only provided for backwards compatibility.
proc imgInvertAlpha*(theOn: cint): cint{.cdecl, importc: "IMG_InvertAlpha",
                                        dynlib: ImageLibName.}
  # Functions to detect a file type, given a seekable source
proc imgIsBMP*(src: PRWops): cint{.cdecl, importc: "IMG_isBMP",
                                   dynlib: ImageLibName.}
proc imgIsGIF*(src: PRWops): cint{.cdecl, importc: "IMG_isGIF",
                                   dynlib: ImageLibName.}
proc imgIsJPG*(src: PRWops): cint{.cdecl, importc: "IMG_isJPG",
                                   dynlib: ImageLibName.}
proc imgIsLBM*(src: PRWops): cint{.cdecl, importc: "IMG_isLBM",
                                   dynlib: ImageLibName.}
proc imgIsPCX*(src: PRWops): cint{.cdecl, importc: "IMG_isPCX",
                                   dynlib: ImageLibName.}
proc imgIsPNG*(src: PRWops): cint{.cdecl, importc: "IMG_isPNG",
                                   dynlib: ImageLibName.}
proc imgIsPNM*(src: PRWops): cint{.cdecl, importc: "IMG_isPNM",
                                   dynlib: ImageLibName.}
proc imgIsTIF*(src: PRWops): cint{.cdecl, importc: "IMG_isTIF",
                                   dynlib: ImageLibName.}
proc imgIsXCF*(src: PRWops): cint{.cdecl, importc: "IMG_isXCF",
                                   dynlib: ImageLibName.}
proc imgIsXPM*(src: PRWops): cint{.cdecl, importc: "IMG_isXPM",
                                   dynlib: ImageLibName.}
proc imgIsXV*(src: PRWops): cint{.cdecl, importc: "IMG_isXV",
                                  dynlib: ImageLibName.}
  # Individual loading functions
proc imgLoadBMP_RW*(src: PRWops): PSurface{.cdecl, importc: "IMG_LoadBMP_RW",
    dynlib: ImageLibName.}
proc imgLoadGIF_RW*(src: PRWops): PSurface{.cdecl, importc: "IMG_LoadGIF_RW",
    dynlib: ImageLibName.}
proc imgLoadJPG_RW*(src: PRWops): PSurface{.cdecl, importc: "IMG_LoadJPG_RW",
    dynlib: ImageLibName.}
proc imgLoadLBM_RW*(src: PRWops): PSurface{.cdecl, importc: "IMG_LoadLBM_RW",
    dynlib: ImageLibName.}
proc imgLoadPCX_RW*(src: PRWops): PSurface{.cdecl, importc: "IMG_LoadPCX_RW",
    dynlib: ImageLibName.}
proc imgLoadPNM_RW*(src: PRWops): PSurface{.cdecl, importc: "IMG_LoadPNM_RW",
    dynlib: ImageLibName.}
proc imgLoadPNG_RW*(src: PRWops): PSurface{.cdecl, importc: "IMG_LoadPNG_RW",
    dynlib: ImageLibName.}
proc imgLoadTGA_RW*(src: PRWops): PSurface{.cdecl, importc: "IMG_LoadTGA_RW",
    dynlib: ImageLibName.}
proc imgLoadTIF_RW*(src: PRWops): PSurface{.cdecl, importc: "IMG_LoadTIF_RW",
    dynlib: ImageLibName.}
proc imgLoadXCF_RW*(src: PRWops): PSurface{.cdecl, importc: "IMG_LoadXCF_RW",
    dynlib: ImageLibName.}
proc imgLoadXPM_RW*(src: PRWops): PSurface{.cdecl, importc: "IMG_LoadXPM_RW",
    dynlib: ImageLibName.}
proc imgLoadXV_RW*(src: PRWops): PSurface{.cdecl, importc: "IMG_LoadXV_RW",
    dynlib: ImageLibName.}
proc imgReadXPMFromArray*(xpm: cstringArray): PSurface{.cdecl,
    importc: "IMG_ReadXPMFromArray", dynlib: ImageLibName.}

proc imageVersion(x: var Version) =
  x.major = IMAGE_MAJOR_VERSION
  x.minor = IMAGE_MINOR_VERSION
  x.patch = IMAGE_PATCHLEVEL

