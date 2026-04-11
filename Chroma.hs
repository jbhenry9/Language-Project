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
         | true
         | false

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
    | BoolLit Bool
    deriving (Show, Eq)

data Value
    = RGBVal RGB
    | HexVal HEX
    | IntVal Int
    | BoolVal Bool
    deriving (Show, Eq)

data RGB
    = RGB Int Int Int
    deriving (Show, Eq)

data HEX
    = HEX String String String
    deriving (Show, Eq)

type Env = [(Var, Value)]


{-
Example program:

swatch sunset = rgb(255, 120, 60)
swatch ocean = hex(00, 66, CC)

if (sunset > ocean) {
    result = mix(sunset, ocean)
    print result
} else {
    print ocean
}
-}


{-
Example AST:

Program
  [ Declare "sunset" (RGBExpr (RGB 255 120 60))
  , Declare "ocean" (HEXExpr (HEX "00" "66" "CC"))
  , If (GreaterColor (ColorVar "sunset") (ColorVar "ocean"))
      [ Assign "result"
          (ColorE (Mix (ColorVar "sunset") (ColorVar "ocean")))
      , Print (ColorE (ColorVar "result"))
      ]
      (Just
        [ Print (ColorE (ColorVar "ocean")) ])
  ]
-}