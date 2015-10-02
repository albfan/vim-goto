nnoremap <silent> <C-B> :call GotoTag(0)<CR>
vnoremap <silent> <C-B> :call GotoTag(1)<CR>

function! GotoVimFunction(word)
  try
    call GotoVim(a:word, 'function', 1, '', '\s*(')
  catch
    try
      call GotoVim(a:word, 'command', 2, '.*', '')
    catch
      echom 'unknown ' . a:word
    endtry
  endtry
endfunction

function! GotoVim(word, type, pos, prefix, suffix)
  let definition = ""
  redir => definition 
    exe "silent verbose " . a:type. " " . a:word
  redir END
  let defsplit = split(definition, "\n")
  let d = defsplit[a:pos]
  let prefix="Last set from "
  if $LANG =~ 'es'
    let prefix = "Se definió por última vez en "
  endif
  let d = substitute(d, '\s*' . prefix , "", "") 
  exe "split " . d
  call search(a:type.'!\?\s*'. a:prefix . a:word . a:suffix) 
endfunction

function! GotoTag(visualmode)
  let word = ""
  if a:visualmode
    let word = VisualSelection()
  endif
  if empty(word)
    let word = expand('<cword>')
  endif
  try
    exe "tag " . word
  catch
    if &filetype == "vim"
      call GotoVimFunction(word)   
    endif 
  endtry
  normal zv
endfunction

function! VisualSelection()
  let selection = ""
  try
    let a_save = @a
    normal! gv"ay
    let selection = @a
  finally
    let @a = a_save
  endtry
  return selection
endfunction
