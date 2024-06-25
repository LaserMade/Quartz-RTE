#Requires AutoHotkey v2.0

;@Link...: https://www.reddit.com/r/AutoHotkey/comments/1cf8x85/comment/l1r2p8z/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
;@Link...: https://www.reddit.com/r/AutoHotkey/comments/1cf8x85/comment/l1r2p8z/

/**
* @example
typedef struct tagPOINT {                 <--The type we're dealing with
  LONG x;                                 <--Data type and description of first item
  LONG y;                                 <--Data type and description of second item
} POINT, *PPOINT, *NPPOINT, *LPPOINT;     <--Don't worry about these
 */

typedef_struct_tagPOINT_bitshift_short(v:=0, &x:=0, &y:=0) {
    x := v << 32 >> 32
    y := v >> 32
}
typedef_struct_tagPOINT_bitshift_long(v:=0, &vx:=0, &vy:=0) {
    vx := v << 32
    vx := vx >> 32
    vy := v >> 32
}
typedef_struct_tagPOINT_buffer(buff:=0, &bx:=0, &by:=0) {
    buff := Buffer(8, 0)
    ; DllCall("GetCursorPos", "int64", buff.Ptr)
    bx := NumGet(buff, 0, 'int')
    by := NumGet(buff, 4, 'int')
}