#ifndef K_ENUM
#define K_ENUM
enum ENTRYMODE {
    ADD_ENTRY,
    EDIT_ENTRY,
    CLONE_ENTRY
};

enum TRANSPORT
{
    NO_TRANSPORT = -1,
    PHONE = 0,
    TCPIP,
    SUPERLAT,
    DIRECT,
    TEMPLATE,
    SSH,
    FTP
};

struct TRANSPORT_IMAGE
{
    ZIL_ICHAR *text;
    ZIL_UINT8 graphic[16 * 8];
};

enum CURSOR_TYPE
{
    FULL_CURSOR,
    HALF_CURSOR,
    UNDERLINE_CURSOR
};

enum TERMINAL
{
    VT320,
    VT220,
    VT102,
    VT100,
    VT52,    
    ANSI,
    TTY,
    WY30,
    WY50,
    WY60,
    WY370,
    DG200,
    SCOANSI,
    AT386,
    AVATAR,
    DG210,
    HEATH19,
    HP2621,
    HZ1500,
    TVI910,
    TVI925,
    TVI950,
    VC404,
    VIP7809,
    HPTERM,
    DG217,
    BEOS,
    QNX,
    QANSI,
    SNI97801,
    BA80,
    AIXTERM,
    HFT,
    LINUX,
    WY160,
    VTNT,
    IBM3151,
    ADM3A,
    SUN,
    ANNARBOR
};

enum PROTOCOL
{
   K_FAST,
   K_CAUTIOUS,
   K_ROBUST,
   Z,
   Y,
   YG,
   X,
   K_CUSTOM
};

enum XFERMODE
{
   BINARY,
   TEXT
};

enum COLLISION
{
   COL_APPEND,
   COL_BACKUP,
   COL_DISCARD,
   COL_OVERWRITE,
   COL_RENAME,
   COL_UPDATE
};

enum UNPREFIX_CC
{
   NEVER,
   CAUTIOUSLY,
   MOST
};

enum TERMCSET 
{
    T_ASCII,
    T_BRITISH,
    T_CANADIAN_FRENCH,
    T_CP437,
    T_CP850,
    T_CP852,
    T_CP862_HEBREW,
    T_CP866_CYRILLIC,
    T_CYRILLIC_ISO,
    T_DANISH,
    T_DEC_MULTINATIONAL,
    T_DG_INTERNATIONAL,
    T_DUTCH,
    T_FINNISH,
    T_FRENCH,
    T_GERMAN,
    T_HEBREW_7,
    T_HEBREW_ISO,
    T_HP_ROMAN_8,
    T_HUNGARIAN,
    T_ITALIAN,
    T_KIO8,
    T_LATIN1_ISO,
    T_LATIN2_ISO,
    T_MACINTOSH_LATIN,
    T_NEXT_MULTINATIONAL,
    T_NORWEGIAN,
    T_PORTUGUESE,
    T_SHORT_KOI,
    T_SPANISH,
    T_SWEDISH,
    T_SWISS,   
    T_TRANSPARENT,
    T_ARABIC_ISO,
    T_JAPANESE_ROMAN,
    T_KATAKANA,
    T_LATIN3_ISO,
    T_LATIN4_ISO,
    T_LATIN5_ISO,
    T_LATIN6_ISO,
    T_DEC_SPECIAL,
    T_DEC_TECHNICAL,
    T_DG_SPECIAL,
    T_DG_LINEDRAW,
    T_DG_WORDPROC,
    T_ELOT927_GREEK,
    T_GREEK_ISO,
    T_CP1250,
    T_CP1251,
    T_CP1252,
    T_CP1253,
    T_CP1254,
    T_CP1257,
    T_QNX_CONSOLE,
    T_SNI_BRACKETS,
    T_SNI_EURO,
    T_SNI_FACET,
    T_SNI_IBM,
    T_HP_MATH,
    T_HP_LINE,
    T_CP857,
    T_CP856,
    T_CP864,
    T_CP869,
    T_CP855,
    T_CP819,
    T_CP912,
    T_CP913, 
    T_CP914,
    T_CP915,
    T_CP1089,
    T_CP813,
    T_CP916,
    T_CP920,
    T_CP1051,
    T_CP858,
    T_8859_15,
    T_CP923,
    T_ELOT928,
    T_CP10000,
    T_CP37,
    T_CP1255,
    T_CP1256,
    T_CP1258,
    T_UTF8,
    T_KOI8_R,
    T_KOI8_U,
    T_MAZOVIA,
    T_SNI_BLANKS,
    T_UTF7
};

enum FILECSET 
{
    F_ASCII,
    F_BRITISH,
    F_CANADIAN_FRENCH,
    F_CP437,
    F_CP850,
    F_CP852,
    F_CP862_HEBREW,
    F_CP866_CYRILLIC,
    F_CYRILLIC_ISO,
    F_DANISH,
    F_DEC_KANJI,
    F_DEC_MULTINATIONAL,
    F_DG_INTERNATIONAL,
    F_DUTCH,
    F_FINNISH,
    F_FRENCH,
    F_GERMAN,
    F_HEBREW_7,
    F_HEBREW_ISO,
    F_HP_ROMAN_8,
    F_HUNGARIAN,
    F_ITALIAN,
    F_JAPAN_EUC,
    F_JIS7_KANJI,
    F_KIO8_CYRILLIC,
    F_LATIN1_ISO,
    F_LATIN2_ISO,
    F_MACINTOSH_LATIN,
    F_NEXT_MULTINATIONAL,
    F_NORWEGIAN,
    F_PORTUGUESE,
    F_SHIFT_JIS_KANJI,
    F_SHORT_KOI,
    F_SPANISH,
    F_SWEDISH,
    F_SWISS,
    F_ELOT927_GREEK,
    F_GREEK_ISO,
    F_CP1250,
    F_CP1251,
    F_CP1252,
    F_CP858,
    F_ELOT928_GREEK,
    F_EUC_JP,
    F_ISO2022_JP,
    F_KOI8_R,
    F_KOI8_U,
    F_LATIN9_ISO,
    F_MAZOVIA_PC,
    F_UCS2,
    F_UTF8,
    F_BULGARIA_PC,
    F_CP855,
    F_CP869
};

enum XFERCSET {
    X_ASCII,
    X_CYRILLIC_ISO,
    X_HEBREW_ISO,
    X_JAPANESE_EUC,
    X_LATIN1_ISO,
    X_LATIN2_ISO,
    X_TRANSPARENT,
    X_GREEK_ISO,
    X_EUC_JP,
    X_LATIN9_ISO,
    X_UCS2,
    X_UTF8
};

enum PARITY
{
   NO_PARITY,
   SPACE,
   MARK,
   EVEN,
   ODD,
   SPACE_8,
   MARK_8,
   EVEN_8,
   ODD_8
};

enum STOPBITS
{
    STOPBITS_1_0,
    STOPBITS_1_5,
    STOPBITS_2_0
};

enum FLOW
{
    NO_FLOW, 
    XON_XOFF,
    RTS_CTS,
    AUTO_FLOW
};

enum BACKSPACE
{
    CTRL_H,
    DEL,
    CTRL_Y
};

enum ENTER
{
    CR,
    CRLF,
    LF
};

enum KEYMAP
{
   VT100_KEY,
   MAPFILE
};

enum DIALMETHOD
{
   Pulse,
   Tone,
   DialMethodDef = Pulse 
};

enum TAPIDIAL
{
    DialWindows,
    DialKermit
};

enum TAPICONV
{
    ConvWindows,
    ConvKermit,
    ConvByLine
};


enum PRINTER_TYPE
{
    PrinterDOS,
    PrinterWindows,
    PrinterFile,
    PrinterPipe,
    PrinterNone
};

enum TELNET_MODE
{
    TelnetRefuse,
    TelnetAccept,
    TelnetRequest,
    TelnetRequire
};

enum THREE_WAY
{
    OFF,
    ON,
    AUTO
};

enum LOGTYPE
{
    LOG_TEXT,
    LOG_BINARY,
    LOG_DEBUG
};

enum TLS_VERIFY 
{
    TLS_VERIFY_NO,
    TLS_VERIFY_PEER,
    TLS_VERIFY_FAIL
};

enum TCPPROTO 
{
    TCP_DEFAULT,
    TCP_EK4LOGIN,
    TCP_EK5LOGIN,
    TCP_K4LOGIN,
    TCP_K5LOGIN,
    TCP_RAW,
    TCP_RLOGIN,
    TCP_TELNET,
    TCP_TELNET_NO_INIT,
    TCP_TELNET_SSL,
    TCP_TELNET_TLS,
    TCP_SSL,
    TCP_TLS
};

enum SSHPROTO
{
    SSH_AUTO,
    SSH_V1,
    SSH_V2
};

enum SSH1_CIPHER 
{
    SSH1_CIPHER_3DES,
    SSH1_CIPHER_BLOWFISH,
    SSH1_CIPHER_DES
};

enum SSH2_AUTH
{
    SSH2_AUTH_EXTERNAL_KEYX,
    SSH2_AUTH_GSSAPI,
    SSH2_AUTH_HOSTBASED,
    SSH2_AUTH_KEYBOARD_INTERACTIVE,
    SSH2_AUTH_PASSWORD,
    SSH2_AUTH_PUBLICKEY,
    SSH2_AUTH_SRP_GEX_SHA1
};

enum SSH2_CIPHERS
{
    SSH2_CIPHER_3DES,
    SSH2_CIPHER_AES128,
    SSH2_CIPHER_AES192,
    SSH2_CIPHER_AES256,
    SSH2_CIPHER_ARCFOUR,
    SSH2_CIPHER_BLOWFISH,
    SSH2_CIPHER_CAST128
};

enum SSH2_MACS
{
    SSH2_MAC_MD5,
    SSH2_MAC_MD5_96,
    SSH2_MAC_RIPEMD160,
    SSH2_MAC_SHA1,
    SSH2_MAC_SHA1_96
};

enum SSH2_HKA
{
    SSH2_HKA_DSA,
    SSH2_HKA_RSA
};

enum SSH_HOST_CHECK
{
    HC_STRICT,
    HC_ASK,
    HC_NONE
};

enum FTP_PL
{
    PL_CLEAR,
    PL_CONFIDENTIAL,
    PL_PRIVATE,
    PL_SAFE
};

enum GUI_RESIZE
{
    RES_SCALE_FONT,
    RES_CHANGE_DIM
};

enum GUI_RUN
{
    RUN_MAX,
    RUN_RES,
    RUN_MIN
};

enum YNA 
{
    YNA_NO,
    YNA_YES,
    YNA_ASK
};
#endif /* K_ENUM */