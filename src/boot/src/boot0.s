; =====================================================================
; CalicOS
; Copyright (C) 2015 David Jolly
; ----------------------
;
; CalicOS is free software: you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation, either version 3 of the License, or
; (at your option) any later version.
; 
; CalicOS is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
; 
; You should have received a copy of the GNU General Public License
; along with this program.  If not, see <http://www.gnu.org/licenses/>.
; =====================================================================

	bits 16
	org 0x7c00

	jmp short _boot				; jump to boot code
	nop

; ========================
; Boot Parameter Section
; ========================

	db 'CALICOS', 0x00			; oem identifier
	dw 0x200				; bytes per sector
	db 0x01					; sectors per cluster
	dw 0x03					; reserved sectors
	db 0x02					; number of fats
	dw 0x200				; root entries
	dw 0x4000				; small number of sectors
	db 0xf8					; media descriptor
	dw 0x200				; sectors per fat
	dw 0x0000				; sectors per track
	dw 0x0000				; number of heads
	dq 0x00000000				; hidden sectors
	dq 0x00000000				; large number of sectors
_drv_number:
	db 0x80					; drive number
	db 0x00					; reserved
	db 0x29					; extended signature
	dq 0x00000000				; volume serial number
	db 'CCBOOTDRV', 0x00, 0x00		; volume label
	db 'FAT16', 0x00, 0x00, 0x00		; system identifier

; ========================
; Boot Code Section
; ========================

_boot:
	cli
	mov ax, cs				; clear registers
	mov ds, ax
	mov es, ax
	mov ss, ax
	mov bp, 0x7c00
	mov sp, 0x7c00				; setup stack
	sti

	call _util_clear			; clear screen
	mov si, _msg_boot
	call _util_print			; print boot message
	mov si, _msg_load
	call _util_print			; print load message

	mov al, 0x02				; read sector count
	mov ch, 0x00				; track to read
	mov cl, 0x02				; sector to read
	mov dh, 0x00				; head to read
	mov dl, [_drv_number]			; driver number to read from
	mov bx, 0x7e00				; memory offset to write into
	mov es, bx
	mov bx, 0x0000
	call _util_read				; read sectors

	mov si, _msg_done
	call _util_print			; print done message
	jmp 0x7e00:0x000			; jump to bootloader
	call _util_freeze

; ========================
; Boot Utilities Section
; ========================

%include './src/boot_util.s'

; ========================
; Boot String Section
; ========================

_msg_boot:
	db 0x0d, 0x0a, '-=CalicOS=-', 0x00

_msg_load:
	db 0x0d, 0x0a, '** Loading bootloader... ', 0x00

; ========================
; Boot Fill Section
; ========================

	times 0x01fe - ($ - $$) db 0x00
	dw 0xaa55
