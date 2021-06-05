# Lilypond guitar string bending
This repository is an extention of parts of the 
[guitar-string-bending](https://github.com/openlilylib/snippets/tree/master/notation-snippets/guitar-string-bending) repository.
Since the whole [snippets](https://github.com/openlilylib/snippets) repository 
is a large collection of LilyPond code, 
this repository contains hard copies of the needed files.

## Usage

### Overview

 - [`\slideIn`](#slideIn)
 - [`\slideInUp`](#slideInUp)
 - [`\slideInDown`](#slideInDown)
 - [`\slideOut`](#slideOut)
 - [`\bend`](#bend)
 - [`\bendHalf`](#bendHalf)
 - [`\bendFull`](#bendFull)
 - [`\bendNext`](#bendNext)
 - [`\bendOn \bendOff`](#bendOn-bendOff)
 - [`\bendGrace`](#bendGrace)
 - [`\preBendHold`](#preBendHold)
 - [`\bendHold`](#bendHold)
 - [`\shiftBend`](#shiftBend)


### **`slideIn`**

TODO: ReadMe

### **`slideInUp`**

Slides into the note from an invisible deeper note.
```
\slideInUp d
```

### **`slideInDown`**

Slides into the note from an invisible higher note.
```
\slideInUp d
```

### **`slideOut`**

Slides out of the given note. 
```
\slideOut d
```

### **`bend`**

TODO: ReadMe

### **`bendHalf`**

Bends an half tone up from the given note.
```
\bendHalf d
```
This causes a bend from `d` to `dis`

### **`bendFull`**

Bends an full tone up from the given note.
```
\bendHalf d
```
This causes a bend from `d` to `e`

### **`bendNext`**

Bends the next note to the 2nd next one.
```
\bendNext d e
\bendNext\acciaccatura d e
```
This causes a bend from `d` to `e`



### **`bendOn bendOff`**

You can activate and deactivate the bending with the following commands:
```
% music...
\bendOn
% bended notes here
\bendOff
```

> Remember to put the music in Voice or TabVoice contexts (not just Staff
> or TabStaff), otherwise you may get an extra staff, as explained in the
> [Usage manual](http://lilypond.org/doc/stable/Documentation/usage/common-errors.html#an-extra-staff-appears).

Within these commands, the parentheses, normally used to notate slurs,
will notate the bendings.  You can write any bending from a half
tone up to any interval (a number over the bending arrow will show
the interval):
```
d8( dis)
d8( e)
d8( f)
```

Bend and release requires the use of a closing parenthesis to close the
bending and a new opening one to start the release:
```
d8( e)( d)
```

### **`bendGrace`**

Pre-bends - when string is bent before plucking it - are supported
through the `\bendGrace` command and two different \preBend commands:
```
\bendGrace { \preBendHold c8( } d2)  r2
\bendGrace { \preBendRelease c8( d)( } c2)  r2
```

### **`preBendHold`**

`\preBendHold` is a simple pre-bend, while `\preBendRelease` allows to
release the bending.

### **`bendHold`**

Finally, there are two commands that control how a bending behaves
along the time.  `\bendHold` allows to hold a bend for a longer time
by using ties:
```
d8( \holdBend e) ~ e2( d)
```

### **`shiftBend`**

`\shiftBend` allows to bend a string in two steps:
```
c4( \shiftBend d)( e2)
```
