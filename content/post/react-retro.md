+++
author = "James Moriarty"
title = "React Retrospective"
date = "2020-08-12"
description = ""
tags = [
  "react"
]
+++

## Typescript

I found components of more than a few hundred lines of code increasingly difficult to refactor or extend. Porting my ES6 code to Typescript reduced this complexity curve and revealed a few subtle defects in the process.

```typescript
export type Action =
  | UndoAction
  | RedoAction
  | OpSetTypeAction
  | OpSetColorAction
  | OpCreateAction
  | OpUpdateAction;

export type Dispatch = (action: Action) => void;
```

## Dependency Injection

Enabled me to isolate tests and easily replicate different corner cases.

```javascript
const getFeedFn = (userName) => Promise.resolve([]),
  component = create(
    <Feed
      className="Feed"
      userName="jamespaulmoriarty"
      getFeedFn={getFeedFn}
    />
  );
```

## Redux

Redux and its tooling proved great for detecting and avoiding mutations. I learnt a lot about javascript common functions and their behavior and performance trying to write immutable code.

```typescript
case ACTION_TYPES.REDO:
  return {
    ...state,
    future: state.future.slice(0, -1),
    history: state.history.slice().concat(state.future.slice(-1)),
  };
```

It took me some time to appreciate `mapDispatchToProps` and how I could remove knowledge of `despatch` from my jsx.

```typescript
const mapDispatchToProps = (dispatch: Dispatch) => {
  return {
    onChangeComplete: (color: any) => {
      dispatch({
        type: ACTION_TYPES.OP_SET_COLOR,
        payload: { color: color.hex },
      });
    },
  };
};
```