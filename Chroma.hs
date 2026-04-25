{- 

<prog> -> [<stmt>]

<stmt> -> swatch <var> "=" <colorexpr>
        | <var> "=" <expr>
        | print <expr>
        | if "(" <boolexpr> ")" "{" [<stmt>] "}"
        | if "(" <boolexpr> ")" "{" [<stmt>] "}" else "{" [<stmt>] "}"

<expr> -> <colorexpr>
        | <intexpr>
        | <boolexpr>

<colorexpr> -> mix "(" <colorexpr> "," <colorexpr> ")"
             | shade "(" <colorexpr> "," <intexpr> ")"
             | tint "(" <colorexpr> "," <intexpr> ")"
             | <var>
             | <rgbval>
             | <hexval>

<intexpr> -> <intval>
          | <var>

<boolexpr> -> <colorexpr> ">" <colorexpr>
           | <colorexpr> "<" <colorexpr>
           | <colorexpr> "==" <colorexpr>

<value> -> <rgbval>
         | <intval>
         | <hexval>

<rgbval> -> rgb "(" <intval> "," <intval> "," <intval> ")"

<hexval> -> hex "(" <hexpair> "," <hexpair> "," <hexpair> ")"

<hexpair> -> <hexnum> <hexnum>

<hexnum> -> 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9
          | a | b | c | d | e | f
          | A | B | C | D | E | F

<intval> -> int

<env> -> [(<var>, <value>)]

-}

type Var = String

data Program
    = Program [Stmt]
    deriving (Show, Eq)

data Stmt
    = Declare Var ColorExpr
    | Assign Var Expr
    | Print Expr
    | If BoolExpr [Stmt] (Maybe [Stmt])
    deriving (Show, Eq)

data Expr
    = ColorE ColorExpr
    | IntE IntExpr
    | BoolE BoolExpr
    deriving (Show, Eq)

data ColorExpr
    = Mix ColorExpr ColorExpr
    | Shade ColorExpr IntExpr
    | Tint ColorExpr IntExpr
    | ColorVar Var
    | RGBExpr RGB
    | HEXExpr HEX
    deriving (Show, Eq)

data IntExpr
    = IntLit Int
    | IntVar Var
    deriving (Show, Eq)

data BoolExpr
    = GreaterColor ColorExpr ColorExpr
    | LessColor ColorExpr ColorExpr
    | EqualColor ColorExpr ColorExpr
    deriving (Show, Eq)

data Value
    = RGBVal RGB
    | HexVal HEX
    | IntVal Int
    deriving (Show, Eq)

data RGB
    = RGB Int Int Int
    deriving (Show, Eq)

data HexChar = Zero | One | Two | Three | Four | Five | Six | Seven | Eight | Nine | LA | LB | LC | LD | LE | LF | UA | UB | UC | UD | UE | UF
    deriving Eq

instance Show HexChar where
    show Zero = "0"
    show One = "1"
    show LA = "a"
    show UA = "A"

type HexValue = (HexChar, HexChar)
data HEX
    = HEX HexValue HexValue HexValue
    deriving (Show, Eq)

type Env = [(Var, Value)]


{-   EXAMPLE


swatch sunset = rgb(255, 120, 60)
swatch ocean = hex(00, 66, CC)
level = 20

if (sunset > ocean) {
    swatch result = mix(sunset, ocean)
    print result
} else {
    print shade(ocean, level)
}

AST

Program
[ Declare "sunset" (RGBExpr (RGB 255 120 60))
, Declare "ocean" (HEXExpr (HEX "00" "66" "CC"))
, Assign "level" (IntE (IntLit 20))
, If
    (GreaterColor (ColorVar "sunset") (ColorVar "ocean"))
    [ Declare "result"
        (Mix (ColorVar "sunset") (ColorVar "ocean"))
    , Print (ColorE (ColorVar "result"))
    ]
    (Just
        [ Print
            (ColorE
            (Shade (ColorVar "ocean") (IntVar "level")))
        ])
]


-}
p1:: Program
p1 = Program [ Declare "sunset" (RGBExpr (RGB 255 120 60))
    , Declare "ocean" (HEXExpr (HEX (Zero, Zero) (Six, Six) (UC, UC)))
    , Assign "level" (IntE (IntLit 20))
    , If
        (GreaterColor (ColorVar "sunset") (ColorVar "ocean"))
        [ Declare "result"
            (Mix (ColorVar "sunset") (ColorVar "ocean"))
        , Print (ColorE (ColorVar "result"))
        ]
        (Just
            [ Print
                (ColorE
                (Shade (ColorVar "ocean") (IntVar "level")))
            ])
    ]