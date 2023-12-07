export const idlFactory = ({ IDL }) => {
  const IndexCanister = IDL.Service({
    'autoScaleLoginCanister' : IDL.Func([IDL.Text], [IDL.Text], []),
    'autoScaleProductCanister' : IDL.Func([IDL.Text], [IDL.Text], []),
    'createLoginCanisterByGroup' : IDL.Func(
        [IDL.Text],
        [IDL.Opt(IDL.Text)],
        [],
      ),
    'createProductCanisterByGroup' : IDL.Func(
        [IDL.Text],
        [IDL.Opt(IDL.Text)],
        [],
      ),
    'getCanistersByPK' : IDL.Func([IDL.Text], [IDL.Vec(IDL.Text)], ['query']),
  });
  return IndexCanister;
};
export const init = ({ IDL }) => { return []; };
