#include <ui_win.hpp>
#define USE_DERIVED_OBJECTS
#include "setup.hpp"
void z_jump_dummy(void) { }   // Bug fix for broken linkers.

static UI_ITEM _userTable[] =
{
	{ ID_END, ZIL_NULLP(void), ZIL_NULLP(ZIL_ICHAR), 0 }
};
UI_ITEM *UI_WINDOW_OBJECT::userTable = _userTable;

static UI_ITEM _objectTable[] =
{
	{ ID_BORDER, ZIL_VOIDF(UIW_BORDER::New), UIW_BORDER::_className, 0 },
	{ ID_BUTTON, ZIL_VOIDF(UIW_BUTTON::New), UIW_BUTTON::_className, 0 },
	{ ID_COMBO_BOX, ZIL_VOIDF(UIW_COMBO_BOX::New), UIW_COMBO_BOX::_className, 0 },
	{ ID_FORMATTED_STRING, ZIL_VOIDF(UIW_FORMATTED_STRING::New), UIW_FORMATTED_STRING::_className, 0 },
	{ ID_GROUP, ZIL_VOIDF(UIW_GROUP::New), UIW_GROUP::_className, 0 },
	{ ID_ICON, ZIL_VOIDF(UIW_ICON::New), UIW_ICON::_className, 0 },
	{ ID_MAXIMIZE_BUTTON, ZIL_VOIDF(UIW_MAXIMIZE_BUTTON::New), UIW_MAXIMIZE_BUTTON::_className, 0 },
	{ ID_MINIMIZE_BUTTON, ZIL_VOIDF(UIW_MINIMIZE_BUTTON::New), UIW_MINIMIZE_BUTTON::_className, 0 },
	{ ID_PROMPT, ZIL_VOIDF(UIW_PROMPT::New), UIW_PROMPT::_className, 0 },
	{ ID_SCROLL_BAR, ZIL_VOIDF(UIW_SCROLL_BAR::New), UIW_SCROLL_BAR::_className, 0 },
	{ ID_STRING, ZIL_VOIDF(UIW_STRING::New), UIW_STRING::_className, 0 },
	{ ID_SYSTEM_BUTTON, ZIL_VOIDF(UIW_SYSTEM_BUTTON::New), UIW_SYSTEM_BUTTON::_className, 0 },
	{ ID_TEXT, ZIL_VOIDF(UIW_TEXT::New), UIW_TEXT::_className, 0 },
	{ ID_TITLE, ZIL_VOIDF(UIW_TITLE::New), UIW_TITLE::_className, 0 },
	{ ID_VT_LIST, ZIL_VOIDF(UIW_VT_LIST::New), UIW_VT_LIST::_className, 0 },
	{ ID_WINDOW, ZIL_VOIDF(UIW_WINDOW::New), UIW_WINDOW::_className, 0 },
	{ ID_END, ZIL_NULLP(void), ZIL_NULLP(ZIL_ICHAR), 0 }
};
UI_ITEM *UI_WINDOW_OBJECT::objectTable = _objectTable;

