<CsoundSynthesizer>
<CsOptions>
--output=trnsfrm3.aiff -r44100 -k441
</CsOptions>
<CsInstruments>
; transform3.orc : wave transform
sr     =  44100
kr     =   4410
ksmps  =     10
nchnls =      2

garvbsig   init   0                                     ; global audio reverb signal initialization

; p4   = amp
; p5   = freq
; p6   = attack time
; p7   = release time
; p8   = vibrato rate (vbrt)
; p9   = vibrato depth (vbdp)
; p10  = vibrato delay {0-1} (vbdp)
; p11  = initial waveform (initwv)
; p12  = destination waveform (endwv)
; p13  = length of crossfade (xfdtm)

    instr 1  ; the transform

itranswv1 = p11  ; initial waveform
itranswv2 = p12  ; crossfade waveform

ifad1 = p3 - (p13 * p3) ; calculate initial fade (% of dur)
ifad2 = p3 - ifad1      ; calculate remaining duration
                        ; ifad1 + ifad2 = p3

irel  =  .01                 ; set vibrato release time
idel1 =  p3 - (p10 * p3)     ; calculate initial delay (% of dur)
isus  =  p3 - (idel1- irel)  ; calculate remaining duration

iamp   =  ampdb(p4)   ; converts dB to amp value
iscale =  iamp * .075 ; scales amp at init to prevent overload
inote  =  cpspch(p5)  ; converts pitchclass to Hz

k3  linseg  0, idel1, p9, isus, p9, irel, 0   ; line seg gen to control delay
k2  oscil   k3, p8, 1                         ; vibrato
k1  linseg  0, p3/3, 1.5, p3/3, .5, p3/3, 0   ; eg for oscils a1 - a6

a6  oscil    iscale * k1,  inote * .65 + k2,  itranswv2    ; oscillators with vibrato added
a5  oscil    iscale * k1,  inote * 1.5 + k2,  itranswv2
a4  oscil    iscale * k1,  inote + k2,  itranswv2
a3  oscil    iscale * k1,  inote * .600 + k2,  itranswv1
a2  oscil    iscale * k1,  inote * 2 + k2,  itranswv1
a1  oscil    iscale * k1,  inote + k2,  itranswv1

kfade    linseg    0, ifad1, 1, ifad2, 0         ; xfade control

asig1  =  kfade * (a1 + a2 + a3)       ; xfade applied to transwv1
asig2  =  (1 - kfade) * (a4 + a5 + a6) ; inverted xfade applied to transwv2

k4  oscil    1, 1/p3, p12                        ; pan controller
    outs1    (asig1 + asig2) * k4                ; left output of direct audio
    outs2    (asig1 + asig2) * (1-k4)            ; right output of direct audio

garvbsig   =  garvbsig + asig1 + asig2           ; add audio to audio receiver prior to pan
        endin


    instr 99   ; global reverb instrument
irvbtime = p4  ; seconds for signal to decay 60 dB

asig2    reverb    garvbsig, irvbtime    ; put global sig into reverb
    outs1    asig2                       ; output reverb signal left
    outs2    asig2                       ; output reverb signal right
garvbsig     =         0                 ; reinitialize
        endin

</CsInstruments>
<CsScore>

f1 0 2048 10 1                                         ; Sine
f2 0 2048 10 1 .5 .3 .25 .2 .167 .14 .125 .111         ; Sawtooth
f3 0 2048 10 1 0  .3    0   .2    0  .14    0   .111   ; Square
f4 0 2048 10 1 1 1 1 .7 .5 .3 .1                       ; Pulse

;p1     p2    p3   p4    p5      p6    p7    p8    p9     p10   p11     p12     p13
;instr  strt  dur  amp   frq     atk   rel   vbrt  vbdp   vbdl  initwv  endwv   xfdtm
i1      0     16    60   8.2     .75   2     .2    3     .5     4       3       2.5
i1     14.5   17     >   8.165   1     2.5   1     4     .75    1       4       4
i1     29     13     >   8.2     2.5   1.5   2     5     .85    2       1       3
i1     34     10    66   8.245   1.5   3     4     7     .99    2       4       6

;p1      p2     p3    p4
;instr   strt   dur   rvbtm
i99      0      44    8
i99     14.5    29.5  8
i99     29      15    8
i99     33      11    8
e

</CsScore>
</CsoundSynthesizer>

