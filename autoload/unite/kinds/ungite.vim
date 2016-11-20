let s:save_cpo = &cpo
set cpo&vim

let s:kind = {
      \ 'name': 'ungite',
      \ 'default_action': 'toggle_staging',
      \ 'action_table': {},
      \ 'alias_table': {},
      \ 'parents': []
      \ }

function! unite#kinds#ungite#define()
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

let s:kind.action_table.toggle_staging = s:action('Toggle the staging of the file')
function! s:kind.action_table.toggle_staging.func(candidates)
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


let s:kind.action_table.stage = s:action('Stage file')
function! s:kind.action_table.stage.func(candidates)
  call s:git('add', a:candidates)
endfunction

let s:kind.action_table.unstage = s:action('Unstage file')
function! s:kind.action_table.unstage.func(candidates)
  call s:git('reset', a:candidates)
endfunction

let s:kind.action_table.revert = s:action('Revert changes')
function! s:kind.action_table.revert.func(candidates)
  call s:git('checkout --', a:candidates)
endfunction

function! s:git(cmd, candidates)
  let paths = map(copy(a:candidates), 'v:val.action__path')
  call system('git ' . a:cmd . ' ' . join(paths, ' '))
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
