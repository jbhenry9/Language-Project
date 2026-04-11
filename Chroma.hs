{-

<prog> -> [<stmt>]

<stmt> -> swatch <var> "=" <expr>
        | <var> "=" <expr>
        | print <expr>
        | if "(" <expr> ")" "{" [<stmt>] "}"
        | if "(" <expr> ")" "{" [<stmt>] "}" else "{" [<stmt>] "}"

<expr> -> mix "(" <expr> "," <expr> ")"
        | shade "(" <expr> "," <expr> ")"
        | tint "(" <expr> "," <expr> ")"
        | <expr> ">" <expr> 
        | <expr> "<" <expr>
        | <expr> "==" <expr>
        | <var>
        | <value>

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
    = Declare Var Expr
    | Assign Var Expr
    | Print Expr
    | If Expr [Stmt] (Maybe [Stmt])
    deriving (Show, Eq)

data Expr
    = Mix Expr Expr
    | Shade Expr Expr
    | Tint Expr Expr
    | Greater Expr Expr
    | Less Expr Expr
    | Equal Expr Expr
    | VarExpr Var
    | ValueExpr Value
    deriving (Show, Eq)

data Value
    = RGBVal RGB
    | HexVal HEX
    | IntVal Int
    deriving (Show, Eq)

data RGB
    = RGB Int Int Int
    deriving (Show, Eq)

data HEX
    = HEX String String String
    deriving (Show, Eq)

type Env = [(Var, Value)]


{-
swatch sunset = rgb(255, 120, 60)
swatch ocean = hex(00, 66, CC)

if (sunset > ocean) {
    swatch result = mix(sunset, ocean)
    print result
} else {
    print ocean
}
  -}


{-
Program
  [ Declare "sunset" (ValueExpr (RGBVal (RGB 255 120 60)))
  , Declare "ocean" (ValueExpr (HexVal (HEX "00" "66" "CC")))
  , If (Greater (VarExpr "sunset") (VarExpr "ocean"))
      [ Declare "result" (Mix (VarExpr "sunset") (VarExpr "ocean"))
      , Print (VarExpr "result")
      ]
      (Just
        [ Print (VarExpr "ocean") ])
  ]
  -}