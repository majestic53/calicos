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
	org 0x0000

	jmp short _boot				; jump to boot code

; ========================
; Boot Code Section
; ========================

_boot:
	cli
	mov ax, 0x7e00				; clear registers
	mov ds, ax
	mov es, ax
	mov ss, ax
	mov bp, 0x7e00
	mov sp, 0x7e00				; setup stack
	sti

	jmp _boot_menu
	mov al, [_var_pos]
	cmp al, 0x00				; compare against load
	jne ._boot_option_1
	call _load
._boot_option_1:
	cmp al, 0x01				; compare against reboot
	jne ._boot_option_end
	call _util_reboot
._boot_option_end:
	call _util_freeze

_boot_menu:
	pusha
._boot_menu_redraw:
	call _util_clear			; clear screen
	mov bh, 0x70				; color
	mov cx, 0x0000				; start row/column
	mov dx, 0x004f				; end row/column
	call _util_print_col
	mov si, _msg_boot
	call _util_print			; print boot message

	mov ah, 0x06
	mov si, _msg_newline
	call _util_print_rep			; print newlines
	mov si, _msg_choose
	call _util_print			; print selection message
	mov ah, 0x02
	mov si, _msg_newline
	call _util_print_rep			; print newlines
	mov si, _msg_border_top_left
	call _util_print			; print top left border
	mov ah, 0x4e
	mov si, _msg_border_hor
	call _util_print_rep			; print horizontal border
	mov si, _msg_border_top_right
	call _util_print			; print top right border
	mov si, _msg_border_vert
	call _util_print			; print virtical border
	mov ah, 0x4e
	mov si, _msg_space
	call _util_print_rep			; print space
	mov si, _msg_border_vert
	call _util_print			; print virtical border
	mov si, _msg_border_vert
	call _util_print			; print virtical border
	mov ah, 0x01
	mov si, _msg_space
	call _util_print_rep			; print space

	mov al, [_var_pos]
	cmp al, 0x00				; compare against load
	jne ._boot_menu_option_0
	mov bh, 0x70				; color
	mov cx, 0x0a02				; start row/column
	mov dx, 0x0a4d				; end row/column
	call _util_print_col
._boot_menu_option_0:
	mov si, _msg_menu_option_0
	call _util_print			; print menu option 0

	mov ah, 0x3f
	mov si, _msg_space
	call _util_print_rep			; print space
	mov si, _msg_border_vert
	call _util_print			; print virtical border
	mov si, _msg_border_vert
	call _util_print			; print virtical border
	mov ah, 0x01
	mov si, _msg_space
	call _util_print_rep			; print space

	mov al, [_var_pos]
	cmp al, 0x01				; compare against reboot
	jne ._boot_menu_option_1
	mov bh, 0x70				; color
	mov cx, 0x0b02				; start row/column
	mov dx, 0x0b4d				; end row/column
	call _util_print_col
._boot_menu_option_1:
	mov si, _msg_menu_option_1
	call _util_print			; print menu option 1

	mov ah, 0x45
	mov si, _msg_space
	call _util_print_rep			; print space
	mov si, _msg_border_vert
	call _util_print			; print virtical border
	mov si, _msg_border_vert
	call _util_print			; print virtical border
	mov ah, 0x4e
	mov si, _msg_space
	call _util_print_rep			; print space
	mov si, _msg_border_vert
	call _util_print			; print virtical border
	mov si, _msg_border_bot_left
	call _util_print			; print bottom left border
	mov ah, 0x4e
	mov si, _msg_border_hor
	call _util_print_rep			; print horizontal border
	mov si, _msg_border_bot_right
	call _util_print			; print bottom right border
	mov ah, 0x0a
	mov si, _msg_newline
	call _util_print_rep			; print newlines

	mov bh, 0x70				; color
	mov cx, 0x1800				; start row/column
	mov dx, 0x184f				; end row/column
	call _util_print_col
	mov si, _msg_copy
	call _util_print			; print copyright message

	call _util_hide_cur			; hide cursor

._boot_menu_wait:
	xor ah, ah
	int 0x16				; wait for keystroke
	cmp ah, 0x1c				; detect enter key
	jne ._boot_menu_up
	jmp ._boot_menu_done
._boot_menu_up:
	cmp ah, 0x48				; detect up key
	jne ._boot_menu_down
	mov al, [_var_pos]
	cmp al, 0x00
	je ._boot_menu_wait
	mov al, 0x00
	mov [_var_pos], al
	jmp ._boot_menu_redraw
._boot_menu_down:
	cmp ah, 0x50				; detect down key
	jne ._boot_menu_wait
	mov al, [_var_pos]
	cmp al, 0x01
	je ._boot_menu_wait
	mov al, 0x01
	mov [_var_pos], al
	jmp ._boot_menu_redraw
._boot_menu_done:
	popa
	ret

_load:
	call _util_clear			; clear screen
	mov si, _msg_load
	call _util_print			; print load message

	; TODO
	mov si, _msg_newline
	call _util_print
	call _util_reboot
	; ---

; ========================
; Boot Utilities Section
; ========================

%include './src/boot_util.s'

_util_hide_cur:
	pusha
	mov ah, 0x0f
	int 0x10
	mov [_var_page_num], bh
	mov ah, 0x02
	mov bh, [_var_page_num]
	mov dh, 0x1a
	mov dl, 0x51
	int 0x10
	popa
	ret

_util_print_rep:
	pusha
._util_print_rep_next:
	cmp ah, 0x00
	je ._util_print_rep_done
	dec ah					; decrement iterator
	push si
	call _util_print			; print string
	pop si
	jmp ._util_print_rep_next
._util_print_rep_done:
	popa
	ret

_util_print_col:
	pusha
	push bx
	push cx
	push dx
	mov ah, 0x07
	mov al, 0x00				; clear
	int 0x10				; scroll window
	pop dx
	pop cx
	pop bx
	popa
	ret

; ========================
; Boot Variable Section
; ========================

_var_page_num:
	db 0					; active page number

_var_pos:
	db 0					; position index (0: load, 1: exit)

; ========================
; Boot String Section
; ========================

_msg_boot:
	db ' CalicOS Boot Loader', 0x00

_msg_border_bot_left:
	db 0xc8, 0x00

_msg_border_bot_right:
	db 0xbc, 0x00

_msg_border_hor:
	db 0xcd, 0x00

_msg_border_top_left:
	db 0xc9, 0x00

_msg_border_top_right:
	db 0xbb, 0x00

_msg_border_vert:
	db 0xba, 0x00

_msg_choose:
	db 'Please select a boot option:', 0x00

_msg_copy:
	db ' Copyright (C) 2015 David Jolly', 0x00

_msg_load:
	db 'Loading kernel...', 0x00

_msg_menu_option_0:
	db '1 Load CalicOS', 0x00

_msg_menu_option_1:
	db '2 Reboot', 0x00

_msg_space:
	db ' ', 0x00

; ========================
; Boot Fill Section
; ========================

	times 0x0400 - ($ - $$) db 0x00
