let s:save_cpo = &cpo
set cpo&vim

let s:unite_source = {
      \ 'name': 'located_session',
      \ 'hooks': {},
      \ }

function! s:unite_source.hooks.on_init(args, context)
  let s:sessions = split(system("locate -b -r '^\\w*Session.vim$'"), '\n')
endfunction

function! s:load_session(x)
  return 'source ' . a:x
endfunction

function! s:shorten(x)
  return substitute(a:x, '[\\\/]\?Session\.vim$', '', '')
endfunction

function! s:unite_source.gather_candidates(args, context)
  " "action__type" is necessary to avoid being added into cmdline-history.
  return map(copy(s:sessions), '{
        \ "word": s:shorten(fnamemodify(v:val, ":~")),
        \ "source": "located_session",
        \ "kind": ["command"],
        \ "action__command": s:load_session(v:val),
        \ "action__type": ": ",
        \ "action__path": v:val,
        \ "action__directory": fnamemodify(v:val, ":h"),
        \ "action__is_invalidate_cache": 0,
        \ }')
endfunction

function! unite#sources#located_session#define()
  return s:unite_source
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
