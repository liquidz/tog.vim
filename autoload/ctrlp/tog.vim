if (exists('g:loaded_ctrlp_tog') && g:loaded_ctrlp_tog) || v:version < 700 || &cp
  finish
endif
let g:loaded_ctrlp_tog = 1

call add(g:ctrlp_ext_vars, {
    \ 'init'     : 'ctrlp#tog#init()',
    \ 'accept'   : 'ctrlp#tog#accept',
    \ 'lname'    : 'tog',
    \ 'sname'    : 'tog',
    \ 'type'     : 'tabs',
    \ 'sort'     : 0,
    \ 'specinput': 0,
    \ })

function! s:link_highlight(from, to) abort
  if !hlexists(a:from)
    exe 'highlight link' a:from a:to
  endif
endfunction

function! s:set_syntax() abort
  call s:link_highlight('TogglProject', 'Title')
  call s:link_highlight('TogglValue', 'Comment')
  syntax match TogglProject ' \[[^\[]\+\]'
  syntax match TogglValue '\zs\t.*\ze$'
endfunction

function! ctrlp#tog#init() abort
  call s:set_syntax()
  let res = []
  let kind = g:ctrlp#tog#operation['kind']
  if kind ==# 'project'
    for project in tog#get_projects()
      call add(res, printf("%s\t%s", project['name'], project['id']))
    endfor
  elseif kind ==# 'entry'
    for entry in tog#get_entries()
      let id = entry['id']
      let desc = entry['description']
      let project = entry['project']
      call add(res, printf("%s [%s]\t%s",
          \ desc,
          \ (project ==# v:null ? 'none' : project),
          \ id))
    endfor
  endif
  return res
endfunction

function! ctrlp#tog#accept(mode, line) abort
  call ctrlp#exit()
  let value = split(a:line, "\t")[1]

  if empty(g:ctrlp#tog#operation['command'])
    echomsg value
  else
    let command = copy(g:ctrlp#tog#operation['command'])
    let option = g:ctrlp#tog#operation['option']
    call add(command, option)
    call add(command, value)

    call job_start(command, {'out_cb': 'tog#callback_handler'})
  endif
endfunction

let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)
function! ctrlp#tog#id() abort
  return s:id
endfunction

