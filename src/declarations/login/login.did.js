export const idlFactory = ({ IDL }) => {
  const AutoScalingCanisterSharedFunctionHook = IDL.Func(
      [IDL.Text],
      [IDL.Text],
      [],
    );
  const ScalingLimitType = IDL.Variant({
    'heapSize' : IDL.Nat,
    'count' : IDL.Nat,
  });
  const ScalingOptions = IDL.Record({
    'autoScalingHook' : AutoScalingCanisterSharedFunctionHook,
    'sizeLimit' : ScalingLimitType,
  });
  const userlogin = IDL.Record({
    'userEmail' : IDL.Text,
    'userPassword' : IDL.Text,
  });
  const UserInfo = IDL.Record({
    'userName' : IDL.Text,
    'userEmail' : IDL.Text,
    'userPassword' : IDL.Text,
    'userConfirmPassword' : IDL.Text,
  });
  const Login = IDL.Service({
    'getPK' : IDL.Func([], [IDL.Text], ['query']),
    'login' : IDL.Func([userlogin], [IDL.Text], []),
    'signUp' : IDL.Func([UserInfo], [IDL.Text], []),
    'skExists' : IDL.Func([IDL.Text], [IDL.Bool], ['query']),
    'transferCycles' : IDL.Func([], [], []),
  });
  return Login;
};
export const init = ({ IDL }) => {
  const AutoScalingCanisterSharedFunctionHook = IDL.Func(
      [IDL.Text],
      [IDL.Text],
      [],
    );
  const ScalingLimitType = IDL.Variant({
    'heapSize' : IDL.Nat,
    'count' : IDL.Nat,
  });
  const ScalingOptions = IDL.Record({
    'autoScalingHook' : AutoScalingCanisterSharedFunctionHook,
    'sizeLimit' : ScalingLimitType,
  });
  return [
    IDL.Record({
      'owners' : IDL.Opt(IDL.Vec(IDL.Principal)),
      'partitionKey' : IDL.Text,
      'scalingOptions' : ScalingOptions,
    }),
  ];
};
