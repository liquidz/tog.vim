if exists('g:loaded_tog')
  finish
endif
let g:loaded_tog = 1

let s:save_cpo = &cpo
set cpo&vim

let s:V = vital#of('tog')
let s:FP = s:V.import('System.Filepath')
let g:tog_bin = get(g:, 'tog_bin', s:FP.join($HOME, 'bin', 'toggl'))

command! TogglStop    call tog#stop()
command! TogglCurrent call tog#current()
command! TogglList    call tog#list()
command! TogglRestart call tog#restart()
command! -nargs=1 TogglStart     call tog#start(<q-args>)
command! -nargs=1 TogglUpdate    call tog#update(<q-args>)
command! -nargs=1 TogglUpdateFor call tog#update_for(<q-args>)

let &cpo = s:save_cpo
unlet s:save_cpo

