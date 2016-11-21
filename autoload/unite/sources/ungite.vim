let s:save_cpo = &cpo
set cpo&vim

let s:source = {
      \ 'name': 'ungite',
      \ 'hooks': {},
      \ 'syntax': 'uniteSource_ungite'
      \ }

let s:statuses = {
      \ ' ': '',
      \ '?': 'untracked',
      \ '!': 'ignored',
      \ 'M': 'modified',
      \ 'A': 'added',
      \ 'D': 'deleted',
      \ 'R': 'renamed',
      \ 'C': 'copied'
      \ }

function! unite#sources#ungite#define()
  return s:source
endfunction

function! s:source.gather_candidates(args, context)
  let status = s:git('status --porcelain')
  return map(status, 's:format(v:val)')
endfunction

function! s:format(line)
  let index_status = strpart(a:line, 0, 1)
  if index_status == '?' || index_status == '!'
    let index_status = ' '
  endif
  let work_status = strpart(a:line, 1, 1)
  let fully_staged = work_status == ' '

  let filename = split(a:line)[1]
  return {
        \ 'word': printf('%-9s %-9s  %s', s:statuses[index_status], s:statuses[work_status], filename),
        \ 'source': s:source.name,
        \ 'kind': ['ungite'],
        \ 'fully_staged': fully_staged,
        \ 'action__path': filename,
        \ 'action__directory': ''
        \ }
endfunction

function! s:source.hooks.on_syntax(args, context)
  syntax match uniteSource__ungite_Path /.*/
        \ contained containedin=uniteSource_ungite
  syntax match uniteSource__ungite_Work /.\{9\}/
        \ contained containedin=uniteSource_ungite
        \ nextgroup=uniteSource__ungite_Path
        \ skipwhite
  highlight default link uniteSource__ungite_Work diffRemoved
  syntax match uniteSource__ungite_Index /.\{9\}/
        \ contained containedin=uniteSource_ungite
        \ nextgroup=uniteSource__ungite_Work
        \ skipwhite
  highlight default link uniteSource__ungite_Index diffAdded
endfunction

function! s:git(cmd)
  return systemlist('git ' . a:cmd)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
