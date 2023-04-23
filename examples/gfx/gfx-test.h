#ifndef GFX_TEST_H
#define GFX_TEST_H

#include <stdio.h>

#include <hardware/custom.h>
#include <hardware/cia.h>
#include <graphics/gfxbase.h>

// #include <clib/exec_protos.h>
// #include <clib/intuition_protos.h>
// #include <clib/graphics_protos.h>

#define TASK_PRIORITY           (20)
#define COLOR00                 (0x180)
#define BPLCON0                 (0x100)
#define BPLCON0_COMPOSITE_COLOR (1 << 9)

// copper instruction macros
#define COP_MOVE(addr, data) addr, data
#define COP_WAIT_END  0xffff, 0xfffe

extern struct GfxBase *GfxBase;
extern struct Custom custom;
extern struct CIA ciaa,ciab;

int main(int, char**);
void mainLoop(void);
BOOL doInit(void);
BOOL initScreen(void *);
void resetScreen(void);

/*
    Copper list
*/
static UWORD __CHIP__ coplist_pal[]= {
    COP_MOVE(BPLCON0, BPLCON0_COMPOSITE_COLOR),
    COP_MOVE(COLOR00, 0xfff),
    0x7c07, 0xfffe,            // wait for 1/3 (0x07, 0x7c)
    COP_MOVE(COLOR00, 0x00f),
    0xda07, 0xfffe,            // wait for 2/3 (0x07, 0xda)
    COP_MOVE(COLOR00, 0xfff),
    COP_WAIT_END
};

static UWORD __CHIP__ coplist_ntsc[] = {
    COP_MOVE(BPLCON0, BPLCON0_COMPOSITE_COLOR),
    COP_MOVE(COLOR00, 0xfff),
    0x6607, 0xfffe,
    COP_MOVE(COLOR00, 0x00f),
    0xb607, 0xfffe,
    COP_MOVE(COLOR00, 0xfff),
    COP_WAIT_END
};

#endif