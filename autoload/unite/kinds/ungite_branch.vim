let s:save_cpo = &cpo
set cpo&vim

let s:kind = {
      \ 'name': 'ungite_branch',
      \ 'default_action': 'git_branch_checkout',
      \ 'action_table': {},
      \ 'alias_table': {},
      \ 'parents': []
      \ }

function! unite#kinds#ungite_branch#define()
  return s:kind
endfunction

function! s:action(description)
  return {
        \ 'description': a:description,
        \ 'is_selectable': 1,
        \ 'is_quit': 1,
        \ 'is_invalidate_cache': 1
        \ }
endfunction

let s:kind.action_table.git_branch_checkout = s:action('git - checkout branch')
function! s:kind.action_table.git_branch_checkout.func(candidates)
  call s:git('checkout', a:candidates)
endfunction

function! s:git(cmd, candidates)
  let paths = map(copy(a:candidates), 'v:val.action__path')
  call system('git ' . a:cmd . ' ' . join(paths, ' '))
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
