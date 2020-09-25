+++
author = "James Moriarty"
title = "React Retrospective"
date = "2020-08-12"
description = "I worked on the following small projects to familiarizing myself with React."
tags = [
  "react"
]
+++

I worked on the following small projects to familiarizing myself with React:

- [Instagram Feed](https://github.com/jamesmoriarty/react-instagram-authless-feed)
- [Redux Paint Application](https://github.com/jamesmoriarty/redux-paint)
- [Email Signature Generator](https://github.com/jamesmoriarty/react-email-signature)

While there were many lessons - here are some points that stood out:

## Typescript

I found components of more than a few hundred lines of code increasingly difficult to refactor or extend. I ported my ES6 code to Typescript and found this reduced the complexity curve and revealed a few subtle defects in the process.

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

Redux and its tooling proved effective at detecting and avoiding mutations. I learnt a lot about common javascript functions and their behavior and performance trying to write immutable code.

```typescript
case ACTION_TYPES.REDO:
  return {
    ...state,
    future: state.future.slice(0, -1),
    history: state.history.slice().concat(state.future.slice(-1)),
  };
```

It took me some time to appreciate `mapDispatchToProps` and how I could remove knowledge of `despatch` from my `jsx`.

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

## Create-React-App

This was the easiest way to be productive quickly without the common catch of being locked-in.
