export const idlFactory = ({ IDL }) => {
  return IDL.Service({
    'get' : IDL.Func([], [IDL.Text], ['query']),
    'get1' : IDL.Func([], [IDL.Text], []),
    'greet' : IDL.Func([IDL.Text], [IDL.Text], []),
  });
};
export const init = ({ IDL }) => { return []; };
