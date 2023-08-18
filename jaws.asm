
; Mr. Jaws patch for Ultima Underworld ][
; by Eden
; feel free to ask me "why?" on Mastodon: @dabbling_duck@oldbytes.space

stack	segment	para	stack	'STACK'
	db	512	dup	(?)
stack	ends

CrOffset	equ	128d
CrOffset1	equ	156d
JawsIndex	equ	0x021F

data	segment

	AsFile	db	"Crit\As.an",0
	CrFile	db	"Crit\Cr37.00",0	
	CrFile1	db	"Crit\Cr37.01",0	
	CrFile2	db	"Crit\Cr37.02",0	
	FileHandle	dw	?
	JawsCrPatch	db	0xAB,0x3F,0x67,0x49,0x7E,0x54,0xAB,0x3F,0x67,0x49,0x7E,0x54,0x67,0x49,0xAB,0x3F,0x67,0x49,0x7E,0x54,0xAB,0x3F,0x67,0x49,0x7E,0x54,0xAB,0x3F
	JawsCr1Patch	dw	12 dup (0x0280)
	JawsCr2Patch	dw	0x0280
	JawsAnPatch	dw	64 dup	(JawsIndex)
	SuccessString	db	"Patch successful! Mr. Jaws awaits...$"
	FailureString	db	"Patch failed. Make sure you're running this file from the UW2 directory.$"
	AlreadyPatchedString	db	"Mr. Jaws patch already installed!$"
	ReadBuffer	db	?
	JawsFrameBuffer	db	2494 dup (?)

	
data ends

code	segment

start:
	push	ds
	mov	ax, data
	mov	ds, ax

	; Patch AS.AN 
	mov	dx, offset AsFile
	mov	ah, 3dh
	mov	al, 2
	int	21h
	jc	error
	mov	FileHandle, ax

	; Check to see if we've already patched
	mov	ah, 0x3F
	mov	bx, FileHandle
	mov	cx, 1
	mov	dx, offset ReadBuffer
	int	21h
	
	mov	ah, 0x1F
	mov	al, byte ptr ReadBuffer
	cmp	ah, al
	je	already_patched

	mov	ah, 42h
	mov	al, 0
	mov	bx, FileHandle
	xor	cx, cx
	xor	dx, dx
	int	21h

	mov	ah, 40h
	mov	dx, offset JawsCrPatch
	xor	cx, cx
	int	21h

	mov	ah, 40h
	mov	dx, offset JawsAnPatch
	mov	bx, FileHandle
	mov	cx, 128d
	int	21h

	; Patch CR37.00

	mov	dx, offset CrFile
	mov	ah, 3dh
	mov	al, 2
	int	21h
	jc	error
	mov	FileHandle, ax

	mov	ah, 42h
	mov	al, 0
	mov	bx, FileHandle
	xor	cx, cx
	mov	dx, CrOffset
	int	21h

	mov	ah, 40h
	mov	dx, offset JawsCrPatch
	mov	cx, 28d
	int	21h

	; Grab the image of Mr. Jaws while we're here

	mov	ah, 42h
	mov	al, 0
	mov	bx, FileHandle
	xor	cx, cx
	mov	dx, 0x3FAB
	int	21h

	mov	ah, 0x3F
	mov	cx, 2492d
	mov	dx, offset JawsFrameBuffer
	int	21h

	; Patch CR37.01

	mov	dx, offset CrFile1
	mov	ah, 3dh
	mov	al, 2
	int	21h
	jc	error
	mov	FileHandle, ax

	mov	ah, 42h
	mov	al, 0
	mov	bx, FileHandle
	xor	cx, cx
	mov	dx, CrOffset1
	int	21h

	mov	ah, 40h
	mov	dx, offset JawsCr1Patch
	mov	cx, 24d
	int	21h

	mov	ah, 42h
	mov	al, 0
	xor	cx, cx
	mov	dx, 640d
	int	21h
	mov	ah, 40h
	mov	cx, 0x9BC
	mov	dx, offset JawsFrameBuffer
	int	21h

	; Patch CR37.02

	mov	dx, offset CrFile2
	mov	ah, 3dh
	mov	al, 2
	int	21h
	jc	error
	mov	FileHandle, ax

	mov	ah, 42h
	mov	al, 0
	mov	bx, FileHandle
	xor	cx, cx
	mov	dx, 0xB6
	int	21h

	mov	ah, 40h
	mov	dx, offset JawsCr2Patch
	mov	cx, 2d
	int	21h

	mov	ah, 42h
	mov	al, 0
	xor	cx, cx
	mov	dx, 640d
	int	21h
	mov	ah, 40h
	mov	cx, 0x9BC
	mov	dx, offset JawsFrameBuffer
	int	21h

	; All done

	mov	ah, 09
	mov	dx, offset SuccessString
	int	21h

	jmp	quit

error:
	mov	ah, 09
	mov	dx, offset FailureString
	int	21h

quit:
	mov	ah, 04ch
	int	21h

already_patched:
	mov	ah, 09
	mov	dx, offset AlreadyPatchedString	
	int	21h
	jmp	quit

code ends
end start




