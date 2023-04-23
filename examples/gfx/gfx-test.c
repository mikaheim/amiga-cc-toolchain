#include "gfx-test.h"

int main(int argc, char **argv) {
    if (doInit()) {
        // Start main loop
        mainLoop();
    }

    // Exit program gracefully, restore old views and copperlist.
    resetScreen();

    return 0;
}

/*
    MAINLOOP should handle all the logic.
*/
void mainLoop(void) {
    do {
        /* Your magic goes here */
    }
    while ((*(volatile UBYTE *)&ciaa.ciapra & CIAF_GAMEPORT0) != FALSE); // Wait for mouse button
}


/*
    Initialize things before mainLoop, like screen, precalculated tables etc.
*/
BOOL doInit(void) {
    // Set Task Priority to get most out of the system for this task.
    SetTaskPri(FindTask(NULL), TASK_PRIORITY);

    /* DO PRECALC HERE */

    // Hide other views (workbench) and initialize Low Res view for us.
    BOOL bPal = initScreen(NULL);

    // Init our copperlist; PAL or NTSC version
    custom.cop1lc = (ULONG) (bPal ? coplist_pal : coplist_ntsc);

    return TRUE;
}

/*
    Initialize view. 
    If view pointer is NULL, we get empty low res view.
    Return value tells us if we have PAL or NTSC in use.
*/
BOOL initScreen(void *view)
{
    LoadView(view);  // Initialize screen
    WaitTOF(); 
    WaitTOF();  // To be sure if old view was in interlaced        
    return ((BOOL)(GfxBase->DisplayFlags & PAL) == PAL);
}

/*
    Restore old view (GfxBase->ActiView) and copperlist (GfxBase->copinit).
*/
void resetScreen(void)
{
    initScreen(GfxBase->ActiView);
    custom.cop1lc = (ULONG)GfxBase->copinit; 
    RethinkDisplay();
}
