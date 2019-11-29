# DosBox Simplified Execution Batches

## These Batch files will *assemble* (with *MASM*) and *link* then *execute* the result

## NOTE1 :
## These files work ONLY with short file names (<= 8 chars without the extension), otherwise it will give File  Does Not Exist message

## NOTE2 :
## These Batch files delete any previous files of previous assembling
## i.e. Delete any previous *`filename.obj`* and *`filename.exe`*


## How To Use:
`Batch name` followed by `filename` without **`asm`** extension
### Example
```
exec_f hello
```
```
exec_s hello
```


### Contains 2 files :
* **`exec_f.bat`** : displays the output of *MASM* and *LINK* in *`masm.log`* and *`link.log`*
   * Can be useful if you had a lot of errors as dosbox does not support scrolling
* **`exec_s.bat`** : displays the output on the screen normally