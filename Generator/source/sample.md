---
title: "Getting Started"
date: 2014-06-13 14:56:02 +0200
category: learn-swift
tags:
  - beginner
  - pokémon
  - tutorial
teaser: "In this first section, we cover variables, constants, type inference, casting, and string interpolation."
layout: sample
---

### Console Output

Use the `print()` function to print to the console:

~~~swift
print("Hello there! Welcome to the world of Pokémon!")
~~~

### Variables

Variables are declared using the keyword `var`, followed by the variable name and [optionally](#type-inference) its type. A value can be assigned to the variable using the `=` operand:

~~~swift
var playerName: String = "Red"
~~~

Variables can be re-assigned:

~~~swift
playerName = "Blue"
~~~

...but cannot be `nil`, unless they are optional[^intro1].

~~~swift
playerName = nil
// -> Error
~~~

### Constants

Constants are declared similarly to [variables](#variables), except they use the
keyword `let` instead:

~~~swift
let gameTitle: String = "Pokémon Red"
~~~

...and cannot be re-assigned:

~~~swift
gameTitle = "Pokémon Blue"
// -> Error
~~~

Like variables, constants cannot be `nil`.

### Type Inference

Type inference refers to the compiler's ability to implicitly determine the type of a variable without having to specify it in the declaration:

~~~swift
var rivalName = "Blue"
~~~

### String Interpolation

Values can be included in strings using a `\` and the desired value between parentheses:

~~~swift
var totalHP = 15
var damage = 10
var currentHP = "Current HP: \(totalHP - damage)"
// -> "Current HP: 5"
~~~
