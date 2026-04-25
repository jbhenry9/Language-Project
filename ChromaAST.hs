module ChromaAST where
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

<rgbval> -> RGB "(" <intval> "," <intval> "," <intval> ")"

<hexval> -> HEX "(" <hexpair> "," <hexpair> "," <hexpair> ")"

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
    deriving (Eq)

instance Show Value where
    show (RGBVal rgb) = show rgb
    show (HexVal hex) = show hex
    show (IntVal n) = show n

data RGB
    = RGB Int Int Int
    deriving (Eq)

{- RGB(255, 255, 255) -}
instance Show RGB where
    show(RGB r g b) =
        "RGB(" ++ show r ++ ", " ++ show g ++ ", " ++ show b ++ ")"

data HexChar = Zero | One | Two | Three | Four | Five | Six | Seven | Eight | Nine | LA | LB | LC | LD | LE | LF | UA | UB | UC | UD | UE | UF
    deriving Eq

instance Show HexChar where
    show Zero = "0"
    show One = "1"
    show Two = "2"
    show Three = "3"
    show Four = "4"
    show Five = "5"
    show Six = "6"
    show Seven = "7"
    show Eight = "8"
    show Nine = "9"
    show LA = "A"
    show LB = "B"
    show LC = "C"
    show LD = "D"
    show LE = "E"
    show LF = "F"
    show UA = "A"
    show UB = "B"
    show UC = "C"
    show UD = "D"
    show UE = "E"
    show UF = "F"

type HexValue = (HexChar, HexChar)

{-AA-}
showHexValue:: HexValue -> String
showHexValue (first, second) = 
    show first ++ show second

data HEX
    = HEX HexValue HexValue HexValue
    deriving (Eq)

{- #AAAAAA -}
instance Show HEX where
    show (HEX r g b) = 
        "#" ++ showHexValue r ++ showHexValue g ++ showHexValue b


type Env = [(Var, Value)]