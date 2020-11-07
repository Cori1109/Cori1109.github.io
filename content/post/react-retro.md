+++
author = "James Moriarty"
title = "React Retrospective"
date = "2020-08-12"
description = "I worked on the following small projects to familiarizing myself with React."
tags = [
  "react",
  "fed"
]
+++

I worked on the following small projects to familiarizing myself with React:

- [Instagram Feed](https://github.com/jamesmoriarty/react-instagram-authless-feed)
- [Redux Paint Application](https://github.com/jamesmoriarty/redux-paint)
- [Email Signature Generator](https://github.com/jamesmoriarty/react-email-signature)

While there were many lessons - here are some points that stood out:

- [Typescript](#typescript)
- [Stateless Components](#stateless-components)
- [Dependency Injection](#dependency-injection)
- [Cloning](#cloning)
- [Error Boundaries](#error-boundaries)
- [Create React App](#create-react-app)

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

## Stateless Components

Unsurprisingly, I found stateless components easier to understand and less error prone.

## Dependency Injection

I used higher order functions to inject dependencies and isolate tests to easily replicate different corner cases.

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

## Cloning

Cloning is useful in some more advanced scenarios. e.g. add/override a event listener without knowledge of the `props.children` component internals.

```javascript
<ColorPicker>
  <Button variant="contained">
    // ...
  </Button>
</ColorPicker>
```

```javascript
function ColorPicker({ children, onChangeComplete, color }) {
  // ...
  return (
    <div>
      {React.cloneElement(children, { onClick: handleClick })}
      // ...
  );
```

## Error Boundaries

I have a lot of appreciation for this [pattern](https://reactjs.org/docs/error-boundaries.html) and would love to see it applied more widely. I did had some initial difficulty applying them to async component lifecycle.

```javascript
componentDidMount() {
  // ...
  .catch((error) => this.setState({ error }));
}

render() {
  if (this.state.error) throw this.state.error;
  // ...
}
```

## Create React App

This was the easiest way to be productive quickly without the common catch of being locked-in.
