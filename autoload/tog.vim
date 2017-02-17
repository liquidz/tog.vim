let s:save_cpo = &cpo
set cpo&vim

" body

let s:V = vital#of('vital')
let s:P = s:V.import('Process')

let g:ctrlp#tog#operation = {}
"let g:ctrlp#tog#kind = ''
"let g:ctrlp#tog#command = []
"let g:ctrlp#tog#option_key = ''

function! tog#start(desc) abort
  let g:ctrlp#tog#operation = {
      \ 'kind':    'project',
      \ 'command': [g:tog_bin, 'start', a:desc],
      \ 'option':  '--project'
      \ }
  "let g:ctrlp#tog#kind = 'project'
  "let g:ctrlp#tog#command = [g:tog_bin, 'start', a:desc]
  "let g:ctrlp#tog#option_key = '--project'
  call ctrlp#init(ctrlp#tog#id())
endfunction

function! tog#stop() abort
  let cmd = [g:tog_bin, 'stop']
  call job_start(cmd, {'out_cb': 'tog#callback_handler'})
endfunction

function! tog#get_projects() abort
  return json_decode(s:P.system(printf('%s project --json', g:tog_bin)))
endfunction

function! tog#get_entries() abort
  return json_decode(s:P.system(printf('%s list --json', g:tog_bin)))
endfunction

function! tog#callback_handler(channel, msg) abort
  echo a:msg
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
