let s:save_cpo = &cpo
set cpo&vim

let s:source = {
      \ 'name': 'ungite/status',
      \ 'hooks': {},
      \ 'syntax': 'uniteSource_ungite_status'
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

function! unite#sources#ungite_status#define()
  return s:source
endfunction

function! s:source.gather_candidates(args, context)
  let status = s:git('status --porcelain')
  call sort(status)
  return map(status, 's:format(v:val)')
endfunction

function! s:format(line)
  let index_status = strpart(a:line, 0, 1)
  if index_status == '?' || index_status == '!'
    let index_status = ' '
  endif
  let work_status = strpart(a:line, 1, 1)
  let fully_staged = work_status == ' '

  " get the last element because of a -> b syntax for renames
  let parts = split(a:line)
  let action__path = parts[-1]
  let file = join(parts[1:-1], ' ')
  return {
        \ 'word': printf('%-9s %-9s  %s', s:statuses[index_status], s:statuses[work_status], file),
        \ 'source': s:source.name,
        \ 'kind': ['ungite_status'],
        \ 'fully_staged': fully_staged,
        \ 'action__path': action__path
        \ }
endfunction

function! s:source.hooks.on_syntax(args, context)
  syntax region uniteSource__ungite_status_Index start='\%1c' end='\%10c'
        \ contains=uniteSource__ungite_status_Untracked,uniteSource__ungite_status_Ignored
  syntax region uniteSource__ungite_status_Work start='\%11c' end='\%21c'
        \ contains=uniteSource__ungite_status_Untracked,uniteSource__ungite_status_Ignored
  syntax match uniteSource__ungite_status_Untracked 'untracked' contained
  syntax match uniteSource__ungite_status_Ignored 'ignored' contained
  syntax match uniteSource__ungite_status_Renamed '->'

  highlight default link uniteSource__ungite_status_Index diffAdded
  highlight default link uniteSource__ungite_status_Work diffRemoved
  highlight default link uniteSource__ungite_status_Untracked gitcommitUntrackedFile
  highlight default link uniteSource__ungite_status_Ignored Comment
  highlight default link uniteSource__ungite_status_Renamed Keyword
endfunction

function! s:git(cmd)
  return systemlist('git ' . a:cmd)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
