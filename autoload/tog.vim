let s:save_cpo = &cpo
set cpo&vim

" body

let s:V = vital#of('vital')
let s:P = s:V.import('Process')

let g:ctrlp#tog#operation = {}

function! tog#start(desc) abort
  let g:ctrlp#tog#operation = {
      \ 'kind':    'project',
      \ 'command': [g:tog_bin, 'start', a:desc],
      \ 'option':  '--project'
      \ }
  call ctrlp#init(ctrlp#tog#id())
endfunction

function! tog#restart() abort
  let g:ctrlp#tog#operation = {
      \ 'kind':    'entry',
      \ 'command': [g:tog_bin, 'restart'],
      \ 'option':  '--id'
      \ }
  call ctrlp#init(ctrlp#tog#id())
endfunction

function! tog#update(args) abort
  let args = split(a:args, ' \+')
  let cmd = extend([g:tog_bin, 'update'], args)
  call job_start(cmd, {'out_cb': 'tog#callback_handler'})
endfunction

function! tog#update_for(args) abort
  let args = split(a:args, ' \+')
  let g:ctrlp#tog#operation = {
      \ 'kind':    'entry',
      \ 'command': extend([g:tog_bin, 'update'], args),
      \ 'option':  '--id'
      \ }
  call ctrlp#init(ctrlp#tog#id())
endfunction

function! tog#stop() abort
  let cmd = [g:tog_bin, 'stop']
  call job_start(cmd, {'out_cb': 'tog#callback_handler'})
endfunction

function! tog#current() abort
  let cmd = [g:tog_bin, 'current']
  call job_start(cmd, {'out_cb': 'tog#callback_handler'})
endfunction

function! tog#list() abort
  let g:ctrlp#tog#operation = {
      \ 'kind':    'entry',
      \ 'command': '',
      \ 'option':  ''
      \ }
  call ctrlp#init(ctrlp#tog#id())
endfunction

function! tog#get_projects() abort
  return json_decode(system(printf('%s project --json', g:tog_bin)))
endfunction

function! tog#get_entries() abort
  return json_decode(system(printf('%s list --json', g:tog_bin)))
endfunction

function! tog#callback_handler(channel, msg) abort
  echo a:msg
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
