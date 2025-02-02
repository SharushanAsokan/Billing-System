dosseg
.model small
.stack 100h
.data
Bill_Sys db '---------------------------------------',0DH,0AH
	 db '--------    BILLING SYSTEM     --------',0DH,0AH
	 db '---------------------------------------$',0

products db '---------------------------------------',0DH,0AH
	 db '--------  CHOOSE THE PRODUCT   --------',0DH,0AH
	 db '---------------------------------------',0DH,0AH 
	 db '1. Product Lays - 10', 0Dh, 0Ah
         db '2. Product Pepsi - 20', 0Dh, 0Ah
         db '3. Product Cheetos - 30', 0Dh, 0Ah
         db '4. Product RedBull - 40', 0Dh, 0Ah
         db '5. Product Gala - 50', 0Dh, 0Ah
         db '6. Product 7-UP - 60', 0Dh, 0Ah
         db '7. Product Sting - 70', 0Dh, 0Ah
         db '8. Product Sprit - 80', 0Dh, 0Ah
         db '9. Product Samosa - 90', 0Dh, 0Ah
         db 'Choose (1-9): $', 0

    prices dw 10, 20, 30, 40, 50, 60, 70, 80, 90
    quantity_prompt db 0Dh, 0Ah, 'Enter quantity: $', 0
    next_action db 0Dh, 0Ah, '1. Add another product', 0Dh, 0Ah
                db '2. Get total bill: $', 0
    
bill db '---------------------------------------',0DH,0AH
     db '-------          BILL           -------',0DH,0AH
     db '---------------------------------------$',0

bill_msg db 0Dh, 0Ah, 'Subtotal: $', 0
    sales_tax_msg db 0Dh, 0Ah, 'Sales Tax (10%): $', 0
    service_tax_msg db 0Dh, 0Ah, 'Service Tax (10%): $', 0
    total_msg db 0Dh, 0Ah, 'Total Bill: $', 0
	
    subtotal dw 0
    sales_tax dw 0
    service_tax dw 0
    total dw 0

.code
main proc
mov ax, @data
mov ds, ax

mov dx, offset Bill_Sys
mov ah, 9         
int 21h

Start:

call newline
mov dx, offset products
mov ah, 9         
int 21h

; Get product choice
mov ah,1
int 21h
sub al,'1'
mov bl,al

; Get quantity
mov dx,offset quantity_prompt
mov ah, 9
int 21h

mov ah, 1
int 21h
sub al, '0'
mov bh, al ; Store quantity

; Calculate subtotal
mov ax, 0
mov al, bl
shl ax, 1
lea si, prices
add si, ax
mov ax, [si]
mul bh
add subtotal, ax

; Ask next action
mov dx,offset next_action
mov ah, 9
int 21h

mov ah, 1
int 21h
sub al, '0'
cmp al, 1
je start

; Calculate sales tax (10%)
mov ax, subtotal
mov cx, 10
mul cx
mov cx,100
div cx
mov sales_tax, ax

; Calculate service tax (10%)
mov ax, subtotal
mov cx, 10
mul cx
mov cx,100
div cx
mov service_tax, ax

; Calculate total bill
mov ax, subtotal
add ax, sales_tax
add ax, service_tax
mov total, ax

call newline
mov dx,offset bill
mov ah,9
int 21h

; Display subtotal
mov dx,offset bill_msg
mov ah, 9
int 21h
mov ax, subtotal
call display_number

; Display sales tax
mov dx,offset sales_tax_msg
mov ah, 9
int 21h
mov ax, sales_tax
call display_number

; Display service tax
mov dx,offset service_tax_msg
mov ah, 9
int 21h
mov ax, service_tax
call display_number

; Display total bill
mov dx,offset total_msg
mov ah, 9
int 21h
mov ax, total
call display_number

; Exit program
mov ah, 4Ch
int 21h

main endp

display_number proc
push ax
push bx
push cx
push dx

mov cx, 0
mov bx, 10

convert_digit:
xor dx, dx
div bx
push dx
inc cx
test ax, ax
jnz convert_digit

print_digit:
pop dx
add dl, '0'
mov ah, 2
int 21h
loop print_digit

pop dx
pop cx
pop bx
pop ax
ret
display_number endp

newline proc
mov dx,10
mov ah,2
int 21h
ret
newline endp

end main


