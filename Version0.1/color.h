namespace Color
{
    enum Code
    {
        FG_RED = 31,
        FG_GREEN = 32,
        FG_YELLOW = 33,
        FG_BLUE = 34,
        FG_MAGENTA = 35,
        FG_CYAN = 36,
        FG_LIGHT_GRAY = 37,
        FG_DEFAULT = 39,
        FG_DARK_GRAY = 90,
        FG_LIGHT_RED = 91,
        FG_LIGHT_GREEN = 92,
        FG_LIGHT_YELLOW = 93,
        FG_LIGHT_BLUE = 94,
        FG_LIGHT_MAGENTA = 95,
        FG_LIGHT_CYAN = 96,
        FG_WHITE = 97,

        BG_RED = 41,
        BG_GREEN = 42,
        BG_YELLOW = 43,
        BG_BLUE = 44,
        BG_MAGENTA = 45,
        BG_CYAN = 46,
        BG_LIGHT_GRAY = 47,
        BG_DEFAULT = 49,
        BG_DARK_GRAY = 100,
        BG_LIGHT_RED = 101,
        BG_LIGHT_GREEN = 102,
        BG_LIGHT_YELLOW = 103,
        BG_LIGHT_BLUE = 104,
        BG_LIGHT_MAGENTA = 105,
        BG_LIGHT_CYAN = 106,
        BG_WHITE = 107,

        BOLD = 1,
        UNDERLINE = 4,
        RESET = 0
    };

    class Modifier
    {
        Code code;

    public:
        Modifier(Code pCode) : code(pCode) {}
        friend std::ostream &
        operator<<(std::ostream &os, const Modifier &mod)
        {
            return os << "\033[" << mod.code << "m";
        }
    };

    Modifier red(Color::FG_RED);
    Modifier green(Color::FG_GREEN);
    Modifier yellow(Color::FG_YELLOW);
    Modifier blue(Color::FG_BLUE);
    Modifier magenta(Color::FG_MAGENTA);
    Modifier cyan(Color::FG_CYAN);
    Modifier lightGray(Color::FG_LIGHT_GRAY);
    Modifier darkGray(Color::FG_DARK_GRAY);
    Modifier lightRed(Color::FG_LIGHT_RED);
    Modifier lightGreen(Color::FG_LIGHT_GREEN);
    Modifier lightYellow(Color::FG_LIGHT_YELLOW);
    Modifier lightBlue(Color::FG_LIGHT_BLUE);
    Modifier lightMagenta(Color::FG_LIGHT_MAGENTA);
    Modifier lightCyan(Color::FG_LIGHT_CYAN);
    Modifier white(Color::FG_WHITE);
    Modifier def(Color::FG_DEFAULT);

    Modifier bgRed(Color::BG_RED);
    Modifier bgGreen(Color::BG_GREEN);
    Modifier bgYellow(Color::BG_YELLOW);
    Modifier bgBlue(Color::BG_BLUE);
    Modifier bgMagenta(Color::BG_MAGENTA);
    Modifier bgCyan(Color::BG_CYAN);
    Modifier bgLightGray(Color::BG_LIGHT_GRAY);
    Modifier bgDarkGray(Color::BG_DARK_GRAY);
    Modifier bgLightRed(Color::BG_LIGHT_RED);
    Modifier bgLightGreen(Color::BG_LIGHT_GREEN);
    Modifier bgLightYellow(Color::BG_LIGHT_YELLOW);
    Modifier bgLightBlue(Color::BG_LIGHT_BLUE);
    Modifier bgLightMagenta(Color::BG_LIGHT_MAGENTA);
    Modifier bgLightCyan(Color::BG_LIGHT_CYAN);
    Modifier bgWhite(Color::BG_WHITE);
    Modifier bgDef(Color::BG_DEFAULT);

    Modifier bold(Color::BOLD);
    Modifier underline(Color::UNDERLINE);
    Modifier reset(Color::RESET);
}