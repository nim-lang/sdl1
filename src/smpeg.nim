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
    SmpegLibName = "smpeg.dll"
elif defined(macosx):
  const
    SmpegLibName = "libsmpeg.dylib"
else:
  const
    SmpegLibName = "libsmpeg.so"
const
  FILTER_INFO_MB_ERROR* = 1
  FILTER_INFO_PIXEL_ERROR* = 2 # Filter info from SMPEG

type
  FilterInfo*{.final.} = object
    yuvMbSquareError*: PUInt16
    yuvPixelSquareError*: PUInt16

  PFilterInfo* = ptr FilterInfo # MPEG filter definition
  PFilter* = ptr Filter # Callback functions for the filter
  FilterCallback* = proc (dest, source: POverlay, region: PRect,
                                 filterInfo: PFilterInfo, data: pointer): pointer{.
      cdecl.}
  FilterDestroy* = proc (filter: PFilter): pointer{.cdecl.} # The filter definition itself
  Filter*{.final.} = object  # The null filter (default). It simply copies the source rectangle to the video overlay.
    flags*: uint32
    data*: pointer
    callback*: FilterCallback
    destroy*: FilterDestroy
{.deprecated: [TFilterInfo: FilterInfo, TFilterCallback: FilterCallback,
              TFilterDestroy: FilterDestroy, TFilter: Filter].}

proc filterNull*(): PFilter{.cdecl, importc: "SMPEGfilter_null",
    dynlib: SmpegLibName.}
  # The bilinear filter. A basic low-pass filter that will produce a smoother image.
proc filterBilinear*(): PFilter{.cdecl,
    importc: "SMPEGfilter_bilinear", dynlib: SmpegLibName.}
  # The deblocking filter. It filters block borders and non-intra coded blocks to reduce blockiness
proc filterDeblocking*(): PFilter{.cdecl,
    importc: "SMPEGfilter_deblocking", dynlib: SmpegLibName.}
  #------------------------------------------------------------------------------
  # SMPEG.h
  #------------------------------------------------------------------------------
const
  MAJOR_VERSION* = 0
  MINOR_VERSION* = 4
  PATCHLEVEL* = 2

type
  TVersion* = object
    major*: byte
    minor*: byte
    patch*: byte

  Pversion* = ptr TVersion # This is the actual SMPEG object
  TSMPEG* = object
  PSMPEG* = ptr TSMPEG        # Used to get information about the SMPEG object
  Info* = object
    hasAudio*: int32
    hasVideo*: int32
    width*: int32
    height*: int32
    currentFrame*: int32
    currentFps*: float64
    audioString*: array[0..79, char]
    audioCurrentFrame*: int32
    currentOffset*: uint32
    totalSize*: uint32
    currentTime*: float64
    totalTime*: float64

  PInfo* = ptr Info # Possible MPEG status codes
{.deprecated: [TInfo: Info].}

const
  STATUS_ERROR* = - 1
  STATUS_STOPPED* = 0
  STATUS_PLAYING* = 1

type
  Status* = int32
  Pstatus* = ptr int32     # Matches the declaration of SDL_UpdateRect()
  TDisplayCallback* = proc (dst: PSurface, x, y: int, w, h: int): pointer{.
      cdecl.} # Create a new SMPEG object from an MPEG file.
              #  On return, if 'info' is not NULL, it will be filled with information
              #  about the MPEG object.
              #  This function returns a new SMPEG object.  Use error() to find out
              #  whether or not there was a problem building the MPEG stream.
              #  The sdl_audio parameter indicates if SMPEG should initialize the SDL audio
              #  subsystem. If not, you will have to use the playaudio() function below
              #  to extract the decoded data.
{.deprecated: [Tstatus: Status].}

proc new*(theFile: cstring, info: PInfo, audio: int): PSMPEG{.cdecl,
    importc: "SMPEG_new", dynlib: SmpegLibName.}
  # The same as above for a file descriptor
proc newDescr*(theFile: int, info: PInfo, audio: int): PSMPEG{.
    cdecl, importc: "SMPEG_new_descr", dynlib: SmpegLibName.}
  #  The same as above but for a raw chunk of data.  SMPEG makes a copy of the
  #   data, so the application is free to delete after a successful call to this
  #   function.
proc newData*(data: pointer, size: int, info: PInfo, audio: int): PSMPEG{.
    cdecl, importc: "SMPEG_new_data", dynlib: SmpegLibName.}
  # Get current information about an SMPEG object
proc getinfo*(mpeg: PSMPEG, info: PInfo){.cdecl,
    importc: "SMPEG_getinfo", dynlib: SmpegLibName.}
  #procedure getinfo(mpeg: PSMPEG; info: Pointer);
  #cdecl; external  SmpegLibName;
  # Enable or disable audio playback in MPEG stream
proc enableaudio*(mpeg: PSMPEG, enable: int){.cdecl,
    importc: "SMPEG_enableaudio", dynlib: SmpegLibName.}
  # Enable or disable video playback in MPEG stream
proc enablevideo*(mpeg: PSMPEG, enable: int){.cdecl,
    importc: "SMPEG_enablevideo", dynlib: SmpegLibName.}
  # Delete an SMPEG object
proc delete*(mpeg: PSMPEG){.cdecl, importc: "SMPEG_delete",
                                  dynlib: SmpegLibName.}
  # Get the current status of an SMPEG object
proc status*(mpeg: PSMPEG): Status{.cdecl, importc: "SMPEG_status",
    dynlib: SmpegLibName.}
  # status
  # Set the audio volume of an MPEG stream, in the range 0-100
proc setVolume*(mpeg: PSMPEG, volume: int){.cdecl,
    importc: "SMPEG_setvolume", dynlib: SmpegLibName.}
  # Set the destination surface for MPEG video playback
  #  'surfLock' is a mutex used to synchronize access to 'dst', and can be NULL.
  #  'callback' is a function called when an area of 'dst' needs to be updated.
  #  If 'callback' is NULL, the default function (SDL_UpdateRect) will be used.
proc setDisplay*(mpeg: PSMPEG, dst: PSurface, surfLock: PMutex,
                       callback: TDisplayCallback){.cdecl,
    importc: "SMPEG_setdisplay", dynlib: SmpegLibName.}
  # Set or clear looping play on an SMPEG object
proc loop*(mpeg: PSMPEG, repeat: int){.cdecl, importc: "SMPEG_loop",
    dynlib: SmpegLibName.}
  # Scale pixel display on an SMPEG object
proc scaleXY*(mpeg: PSMPEG, width, height: int){.cdecl,
    importc: "SMPEG_scaleXY", dynlib: SmpegLibName.}
proc scale*(mpeg: PSMPEG, scale: int){.cdecl, importc: "SMPEG_scale",
    dynlib: SmpegLibName.}
proc double*(mpeg: PSMPEG, doubleit: bool)
  # Move the video display area within the destination surface
proc move*(mpeg: PSMPEG, x, y: int){.cdecl, importc: "SMPEG_move",
    dynlib: SmpegLibName.}
  # Set the region of the video to be shown
proc setDisplayRegion*(mpeg: PSMPEG, x, y, w, h: int){.cdecl,
    importc: "SMPEG_setdisplayregion", dynlib: SmpegLibName.}
  # Play an SMPEG object
proc play*(mpeg: PSMPEG){.cdecl, importc: "SMPEG_play",
                                dynlib: SmpegLibName.}
  # Pause/Resume playback of an SMPEG object
proc pause*(mpeg: PSMPEG){.cdecl, importc: "SMPEG_pause",
                                 dynlib: SmpegLibName.}
  # Stop playback of an SMPEG object
proc stop*(mpeg: PSMPEG){.cdecl, importc: "SMPEG_stop",
                                dynlib: SmpegLibName.}
  # Rewind the play position of an SMPEG object to the beginning of the MPEG
proc rewind*(mpeg: PSMPEG){.cdecl, importc: "SMPEG_rewind",
                                  dynlib: SmpegLibName.}
  # Seek 'bytes' bytes in the MPEG stream
proc seek*(mpeg: PSMPEG, bytes: int){.cdecl, importc: "SMPEG_seek",
    dynlib: SmpegLibName.}
  # Skip 'seconds' seconds in the MPEG stream
proc skip*(mpeg: PSMPEG, seconds: float32){.cdecl, importc: "SMPEG_skip",
    dynlib: SmpegLibName.}
  # Render a particular frame in the MPEG video
  #   API CHANGE: This function no longer takes a target surface and position.
  #               Use setdisplay() and move() to set this information.
proc renderFrame*(mpeg: PSMPEG, framenum: int){.cdecl,
    importc: "SMPEG_renderFrame", dynlib: SmpegLibName.}
  # Render the last frame of an MPEG video
proc renderFinal*(mpeg: PSMPEG, dst: PSurface, x, y: int){.cdecl,
    importc: "SMPEG_renderFinal", dynlib: SmpegLibName.}
  # Set video filter
proc filter*(mpeg: PSMPEG, filter: PFilter): PFilter{.cdecl,
    importc: "SMPEG_filter", dynlib: SmpegLibName.}
  # Return NULL if there is no error in the MPEG stream, or an error message
  #   if there was a fatal error in the MPEG stream for the SMPEG object.
proc error*(mpeg: PSMPEG): cstring{.cdecl, importc: "SMPEG_error",
    dynlib: SmpegLibName.}
  # Exported callback function for audio playback.
  #   The function takes a buffer and the amount of data to fill, and returns
  #   the amount of data in bytes that was actually written.  This will be the
  #   amount requested unless the MPEG audio has finished.
  #
proc playAudio*(mpeg: PSMPEG, stream: pointer, length: int): int{.cdecl,
    importc: "SMPEG_playAudio", dynlib: SmpegLibName.}
  # Wrapper for playAudio() that can be passed to SDL and SDL_mixer
proc playAudioSDL*(mpeg: pointer, stream: pointer, length: int){.cdecl,
    importc: "SMPEG_playAudioSDL", dynlib: SmpegLibName.}
  # Get the best SDL audio spec for the audio stream
proc wantedSpec*(mpeg: PSMPEG, wanted: PAudioSpec): int{.cdecl,
    importc: "SMPEG_wantedSpec", dynlib: SmpegLibName.}
  # Inform SMPEG of the actual SDL audio spec used for sound playback
proc actualSpec*(mpeg: PSMPEG, spec: PAudioSpec){.cdecl,
    importc: "SMPEG_actualSpec", dynlib: SmpegLibName.}
  # This macro can be used to fill a version structure with the compile-time
  #  version of the SDL library.
proc getversion*(x: var TVersion) =
  x.major = MAJOR_VERSION
  x.minor = MINOR_VERSION
  x.patch = PATCHLEVEL

proc double(mpeg: PSMPEG, doubleit: bool) =
  if doubleit: scale(mpeg, 2)
  else: scale(mpeg, 1)
