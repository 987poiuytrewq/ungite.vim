let s:save_cpo = &cpo
set cpo&vim

let s:source = {
      \ "name": "ungite"
      \ }

let s:statuses = {
      \ "?": "untracked ",
      \ "!": "ignored   ",
      \ "M": "updated   ",
      \ "A": "added     ",
      \ "D": "deleted   ",
      \ "R": "renamed   ",
      \ "C": "copied    "
      \ }

function! s:source.gather_candidates(args, context)
  let status = s:git("status --porcelain")
  return map(status, '{
        \ "word": s:format(v:val),
        \ "source": s:source.name,
        \ "kind": ["file"],
        \ "action__path": "",
        \ "action__directory": ""
        \ }')
endfunction

function! unite#sources#ungite#define()
  return s:source
endfunction

function! s:format(line)
  let parts = split(a:line)
  return s:statuses[strpart(parts[0], 0, 1)] . parts[1]
endfunction

function! s:git(cmd)
  return systemlist("git " . a:cmd)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
