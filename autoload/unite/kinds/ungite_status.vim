let s:save_cpo = &cpo
set cpo&vim

let s:kind = {
      \ 'name': 'ungite_status',
      \ 'default_action': 'git_toggle_staging',
      \ 'action_table': {},
      \ 'alias_table': {},
      \ 'parents': ['file']
      \ }

function! unite#kinds#ungite_status#define()
  return s:kind
endfunction

function! s:action(description)
  return {
        \ 'description': a:description,
        \ 'is_selectable': 1,
        \ 'is_quit': 0,
        \ 'is_invalidate_cache': 1
        \ }
endfunction

let s:kind.action_table.git_toggle_staging = s:action('git - toggle staging of file')
function! s:kind.action_table.git_toggle_staging.func(candidates)
  call s:toggle(a:candidates)
endfunction

function! s:toggle(candidates)
  for candidate in a:candidates
    if candidate.fully_staged
      call system('git reset ' . candidate.action__path))
    else
      call system('git add ' . candidate.action__path))
  endfor
endfunction


let s:kind.action_table.git_add = s:action('git - add file to staging')
function! s:kind.action_table.git_add.func(candidates)
  call s:git('add', a:candidates)
endfunction

let s:kind.action_table.git_reset = s:action('git - reset file from staging')
function! s:kind.action_table.git_reset.func(candidates)
  call s:git('reset', a:candidates)
endfunction

let s:kind.action_table.git_checkout = s:action('git - checkout file')
function! s:kind.action_table.git_checkout.func(candidates)
  call s:git('checkout --', a:candidates)
endfunction

function! s:git(cmd, candidates)
  let paths = map(copy(a:candidates), 'v:val.action__path')
  call system('git ' . a:cmd . ' ' . join(paths, ' '))
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
