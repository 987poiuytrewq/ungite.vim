let s:save_cpo = &cpo
set cpo&vim

let s:source = {
      \ 'name': 'ungite/branch',
      \ 'hooks': {},
      \ 'syntax': 'uniteSource_ungite_branch'
      \ }

let s:current_indicator = '>'

function! unite#sources#ungite_branch#define()
  return s:source
endfunction

function! s:source.gather_candidates(args, context)
  let branches = s:git('branch')
  return map(branches, 's:format(v:val)')
endfunction

function! s:format(line)
  let branch = split(strpart(a:line, 2))[0]
  return {
        \ 'word': substitute(a:line, '^*', s:current_indicator),
        \ 'source': s:source.name,
        \ 'kind': ['ungite_branch'],
        \ 'branch': branch
        \ }
end

function! s:git(cmd)
  return systemlist('git ' . a:cmd)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
