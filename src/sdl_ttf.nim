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
    ttfLibName = "SDL_ttf.dll"
elif defined(macosx):
  const
    ttfLibName = "libSDL_ttf-2.0.0.dylib"
else:
  const
    ttfLibName = "libSDL_ttf(|-2.0).so(|.1|.0)"
const
  MAJOR_VERSION* = 2
  MINOR_VERSION* = 0
  PATCHLEVEL* = 8      # Backwards compatibility

  STYLE_NORMAL* = 0x00000000
  STYLE_BOLD* = 0x00000001
  STYLE_ITALIC* = 0x00000002
  STYLE_UNDERLINE* = 0x00000004 # ZERO WIDTH NO-BREAKSPACE (Unicode byte order mark)
  UNICODE_BOM_NATIVE* = 0x0000FEFF
  UNICODE_BOM_SWAPPED* = 0x0000FFFE

type
  PFont* = ptr Font
  Font = object
{.deprecated: [TFont: Font].}


# This macro can be used to fill a version structure with the compile-time
# version of the SDL_ttf library.

proc linkedVersion*(): sdl.Pversion{.cdecl, importc: "TTF_Linked_Version",
                                      dynlib: ttfLibName.}
  # This function tells the library whether UNICODE text is generally
  #   byteswapped.  A UNICODE BOM character in a string will override
  #   this setting for the remainder of that string.
  #
proc byteSwappedUNICODE*(swapped: cint){.cdecl,
    importc: "TTF_ByteSwappedUNICODE", dynlib: ttfLibName.}
  #returns 0 on succes, -1 if error occurs
proc init*(): cint{.cdecl, importc: "TTF_Init", dynlib: ttfLibName.}
  #
  # Open a font file and create a font of the specified point size.
  # Some .fon fonts will have several sizes embedded in the file, so the
  # point size becomes the index of choosing which size.  If the value
  # is too high, the last indexed size will be the default.
  #
proc openFont*(filename: cstring, ptsize: cint): PFont{.cdecl,
    importc: "TTF_OpenFont", dynlib: ttfLibName.}
proc openFontIndex*(filename: cstring, ptsize: cint, index: int32): PFont{.
    cdecl, importc: "TTF_OpenFontIndex", dynlib: ttfLibName.}
proc openFontRW*(src: PRWops, freesrc: cint, ptsize: cint): PFont{.cdecl,
    importc: "TTF_OpenFontRW", dynlib: ttfLibName.}
proc openFontIndexRW*(src: PRWops, freesrc: cint, ptsize: cint, index: int32): PFont{.
    cdecl, importc: "TTF_OpenFontIndexRW", dynlib: ttfLibName.}
proc getFontStyle*(font: PFont): cint{.cdecl,
    importc: "TTF_GetFontStyle", dynlib: ttfLibName.}
proc setFontStyle*(font: PFont, style: cint){.cdecl,
    importc: "TTF_SetFontStyle", dynlib: ttfLibName.}
  # Get the total height of the font - usually equal to point size
proc fontHeight*(font: PFont): cint{.cdecl, importc: "TTF_FontHeight",
    dynlib: ttfLibName.}
  # Get the offset from the baseline to the top of the font
  #   This is a positive value, relative to the baseline.
  #
proc fontAscent*(font: PFont): cint{.cdecl, importc: "TTF_FontAscent",
    dynlib: ttfLibName.}
  # Get the offset from the baseline to the bottom of the font
  #   This is a negative value, relative to the baseline.
  #
proc fontDescent*(font: PFont): cint{.cdecl, importc: "TTF_FontDescent",
    dynlib: ttfLibName.}
  # Get the recommended spacing between lines of text for this font
proc fontLineSkip*(font: PFont): cint{.cdecl,
    importc: "TTF_FontLineSkip", dynlib: ttfLibName.}
  # Get the number of faces of the font
proc fontFaces*(font: PFont): int32{.cdecl, importc: "TTF_FontFaces",
    dynlib: ttfLibName.}
  # Get the font face attributes, if any
proc fontFaceIsFixedWidth*(font: PFont): cint{.cdecl,
    importc: "TTF_FontFaceIsFixedWidth", dynlib: ttfLibName.}
proc fontFaceFamilyName*(font: PFont): cstring{.cdecl,
    importc: "TTF_FontFaceFamilyName", dynlib: ttfLibName.}
proc fontFaceStyleName*(font: PFont): cstring{.cdecl,
    importc: "TTF_FontFaceStyleName", dynlib: ttfLibName.}
  # Get the metrics (dimensions) of a glyph
proc glyphMetrics*(font: PFont, ch: uint16, minx: var cint,
                       maxx: var cint, miny: var cint, maxy: var cint,
                       advance: var cint): cint{.cdecl,
    importc: "TTF_GlyphMetrics", dynlib: ttfLibName.}
  # Get the dimensions of a rendered string of text
proc sizeText*(font: PFont, text: cstring, w: var cint, y: var cint): cint{.
    cdecl, importc: "TTF_SizeText", dynlib: ttfLibName.}
proc sizeUTF8*(font: PFont, text: cstring, w: var cint, y: var cint): cint{.
    cdecl, importc: "TTF_SizeUTF8", dynlib: ttfLibName.}
proc sizeUNICODE*(font: PFont, text: PUInt16, w: var cint, y: var cint): cint{.
    cdecl, importc: "TTF_SizeUNICODE", dynlib: ttfLibName.}
  # Create an 8-bit palettized surface and render the given text at
  #   fast quality with the given font and color.  The 0 pixel is the
  #   colorkey, giving a transparent background, and the 1 pixel is set
  #   to the text color.
  #   This function returns the new surface, or NULL if there was an error.
  #
proc renderUTF8Solid*(font: PFont, text: cstring, fg: Color): PSurface{.
    cdecl, importc: "TTF_RenderUTF8_Solid", dynlib: ttfLibName.}
proc renderUNICODE_Solid*(font: PFont, text: PUInt16, fg: Color): PSurface{.
    cdecl, importc: "TTF_RenderUNICODE_Solid", dynlib: ttfLibName.}
  #
  #Create an 8-bit palettized surface and render the given glyph at
  #   fast quality with the given font and color.  The 0 pixel is the
  #   colorkey, giving a transparent background, and the 1 pixel is set
  #   to the text color.  The glyph is rendered without any padding or
  #   centering in the X direction, and aligned normally in the Y direction.
  #   This function returns the new surface, or NULL if there was an error.
  #
proc renderGlyphSolid*(font: PFont, ch: uint16, fg: Color): PSurface{.
    cdecl, importc: "TTF_RenderGlyph_Solid", dynlib: ttfLibName.}
  # Create an 8-bit palettized surface and render the given text at
  #   high quality with the given font and colors.  The 0 pixel is background,
  #   while other pixels have varying degrees of the foreground color.
  #   This function returns the new surface, or NULL if there was an error.
  #
proc renderTextShaded*(font: PFont, text: cstring, fg: Color,
                            bg: Color): PSurface{.cdecl,
    importc: "TTF_RenderText_Shaded", dynlib: ttfLibName.}
proc renderUTF8Shaded*(font: PFont, text: cstring, fg: Color,
                            bg: Color): PSurface{.cdecl,
    importc: "TTF_RenderUTF8_Shaded", dynlib: ttfLibName.}
proc renderUNICODE_Shaded*(font: PFont, text: PUInt16, fg: Color,
                               bg: Color): PSurface{.cdecl,
    importc: "TTF_RenderUNICODE_Shaded", dynlib: ttfLibName.}
  # Create an 8-bit palettized surface and render the given glyph at
  #   high quality with the given font and colors.  The 0 pixel is background,
  #   while other pixels have varying degrees of the foreground color.
  #   The glyph is rendered without any padding or centering in the X
  #   direction, and aligned normally in the Y direction.
  #   This function returns the new surface, or NULL if there was an error.
  #
proc renderGlyphShaded*(font: PFont, ch: uint16, fg: Color, bg: Color): PSurface{.
    cdecl, importc: "TTF_RenderGlyph_Shaded", dynlib: ttfLibName.}
  # Create a 32-bit ARGB surface and render the given text at high quality,
  #   using alpha blending to dither the font with the given color.
  #   This function returns the new surface, or NULL if there was an error.
  #
proc renderTextBlended*(font: PFont, text: cstring, fg: Color): PSurface{.
    cdecl, importc: "TTF_RenderText_Blended", dynlib: ttfLibName.}
proc renderUTF8Blended*(font: PFont, text: cstring, fg: Color): PSurface{.
    cdecl, importc: "TTF_RenderUTF8_Blended", dynlib: ttfLibName.}
proc RenderUNICODE_Blended*(font: PFont, text: PUInt16, fg: Color): PSurface{.
    cdecl, importc: "TTF_RenderUNICODE_Blended", dynlib: ttfLibName.}
  # Create a 32-bit ARGB surface and render the given glyph at high quality,
  #   using alpha blending to dither the font with the given color.
  #   The glyph is rendered without any padding or centering in the X
  #   direction, and aligned normally in the Y direction.
  #   This function returns the new surface, or NULL if there was an error.
  #
proc renderGlyphBlended*(font: PFont, ch: uint16, fg: Color): PSurface{.
    cdecl, importc: "TTF_RenderGlyph_Blended", dynlib: ttfLibName.}
  # For compatibility with previous versions, here are the old functions
  # #define TTF_RenderText(font, text, fg, bg)
  #	TTF_RenderText_Shaded(font, text, fg, bg)
  # #define TTF_RenderUTF8(font, text, fg, bg)
  #	TTF_RenderUTF8_Shaded(font, text, fg, bg)
  # #define TTF_RenderUNICODE(font, text, fg, bg)
  #	TTF_RenderUNICODE_Shaded(font, text, fg, bg)
  # Close an opened font file
proc closeFont*(font: PFont){.cdecl, importc: "TTF_CloseFont",
                                      dynlib: ttfLibName.}
  # De-initialize TTF engine
proc quit*(){.cdecl, importc: "TTF_Quit", dynlib: ttfLibName.}
  # Check if the TTF engine is initialized
proc wasInit*(): cint{.cdecl, importc: "TTF_WasInit", dynlib: ttfLibName.}


proc version*(x: var sdl.Version) =
  x.major = MAJOR_VERSION
  x.minor = MINOR_VERSION
  x.patch = PATCHLEVEL


proc renderTextSolid*(font: PFont, text: cstring, fg: Color): PSurface{.
    cdecl, importc: "TTF_RenderText_Solid", dynlib: ttfLibName.}
