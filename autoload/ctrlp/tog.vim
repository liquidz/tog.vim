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

function! ctrlp#tog#init() abort
  let res = []
  let kind = g:ctrlp#tog#operation['kind']
  if kind ==# 'project'
    for project in tog#get_projects()
      call add(res, printf("%s\t%s", project['name'], project['id']))
    endfor
  else if kind ==# 'entry'
    for entry in tog#get_entries()
      let id = entry['id']
      let desc = entry['description']
      call add(res, printf("%s\t%s", desc, id))
    endfor
  endif
  return res
endfunction

function! ctrlp#tog#accept(mode, line) abort
  call ctrlp#exit()
  let value = split(a:line, "\t")[1]

  let command = copy(g:ctrlp#tog#operation['command'])
  let option = g:ctrlp#tog#operation['option']
  call add(command, option)
  call add(command, value)

  call job_start(command, {'out_cb': 'tog#callback_handler'})
endfunction

let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)
function! ctrlp#tog#id() abort
  return s:id
endfunction

