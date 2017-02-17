if exists('g:loaded_tog')
  finish
endif
let g:loaded_tog = 1

let s:save_cpo = &cpo
set cpo&vim

let s:V = vital#of('tog')
let s:FP = s:V.import('System.Filepath')
let g:tog_bin = get(g:, 'tog_bin', s:FP.join($HOME, 'bin', 'toggl'))

command! TogglStop call tog#stop()
command! -nargs=1 TogglStart call tog#start(<q-args>)

let &cpo = s:save_cpo
unlet s:save_cpo

