
; Mr. Jaws patch for Ultima Underworld ][
; by Eden
; feel free to ask me "why?" on Mastodon: @dabbling_duck@oldbytes.space

stack	segment	para	stack	'STACK'
	db	512	dup	(?)
stack	ends

CrOffset	equ	128d
JawsIndex	equ	0x021F

data	segment

	AsFile	db	"Crit\As.an",0
	CrFile	db	"Crit\Cr37.00",0	
	FileHandle	dw	?
	JawsCrPatch	db	0xAB,0x3F,0x67,0x49,0x7E,0x54,0xAB,0x3F,0x67,0x49,0x7E,0x54,0x67,0x49,0xAB,0x3F,0x67,0x49,0x7E,0x54,0xAB,0x3F,0x67,0x49,0x7E,0x54,0xAB,0x3F
	JawsAnPatch	dw	64 dup	(JawsIndex)
	SuccessString	db	"Patch successful! Mr. Jaws awaits...$"
	FailureString	db	"Patch failed. Make sure you're running this file from the UW2 directory.$"
	AlreadyPatchedString	db	"Mr. Jaws patch already installed!$"
	ReadBuffer	db	?

	
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




