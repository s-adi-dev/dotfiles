```markdown
# Astal `Variable` Object

The `Variable` object in Astal is a simple construct designed to hold a single value. It offers various methods to interact with this value, facilitating reactive programming within the framework.

## Importing `Variable`

To utilize the `Variable` object, import it from the `astal` package:

```typescript
import { Variable } from "astal";
```

## Basic Usage

You can create a `Variable`, subscribe to its changes, set new values, and bind it to widgets:

```typescript
const myVar = Variable("initial-value");

// Subscribe to value changes
myVar.subscribe((value: string) => {
    console.log(value);
});

// Set a new value
myVar.set("new value");

// Get the current value
const value = myVar.get();

// Bind to a widget
Widget.Label({
    label: myVar((value) => `transformed ${value}`), // shorthand for binding
});
```

**Note:** Ensure that the transform functions passed to `.as()` are pure. The `.get()` function can be called at any time by Astal, especially when deriving, so it's crucial to avoid side effects.

## Variable Composition

Astal allows for composing multiple `Subscribable` objects using `Variable.derive`. This is useful when you want a variable that depends on other variables:

```typescript
const v1 = Variable(1);
const v2 = bind(obj, "prop");
const v3 = {
    get: () => 3,
    subscribe: () => () => {},
};

// First argument is a list of dependencies
// Second argument is a transform function,
// where the parameters are the values of the dependencies in the order they were passed
const v4 = Variable.derive(
    [v1, v2, v3],
    (v1: number, v2: number, v3: number) => {
        return v1 * v2 * v3;
    }
);
```

**Note:** The types are only for demonstration purposes; you do not have to declare the type of a `Variable`, as they will be inferred from their initial value.

## Subprocess Shortcuts

The `Variable` object provides `.poll` and `.watch` methods to start subprocesses and capture their output:

```typescript
const myVar = Variable(0)
    .poll(1000, "command", (out: string, prev: number) => parseInt(out))
    .poll(1000, ["bash", "-c", "command"], (out, prev) => parseInt(out))
    .poll(1000, (prev) => prev + 1);
```

**Important:** The command parameter is passed to `execAsync`, which means they are not executed in a shell environment. They do not expand environment variables like `$HOME`, and they do not handle logical operators like `&&` and `||`. If you want bash, run them with bash:

```javascript
Variable("").poll(1000, ["bash", "-c", "command $VAR && command"]);
```


You can temporarily stop and restart these subprocesses as needed:

```javascript
myVar.stopWatch(); // This kills the subprocess
myVar.stopPoll();

myVar.startListen(); // Launches the subprocess again
myVar.startPoll();

console.log(myVar.isListening());
console.log(myVar.isPolling());
```

## GObject Connection Shortcuts

You can connect GObject signals to a `Variable` using the `.observe` method:

```typescript
const myVar = Variable("")
    .observe(obj1, "signal", () => "")
    .observe(obj2, "signal", () => "");
```

## Disposal

When a `Variable` is no longer needed, it's important to dispose of it properly to stop intervals, terminate subprocesses, and disconnect GObject signals:

```javascript
myVar.drop();
```

**Warning:** Don't forget to drop derived variables or variables with either `.poll`, `.watch`, or `.observe` when they are defined inside closures:

```tsx
function MyWidget() {
    const myVar = Variable().poll();
    const derived = Variable.derive();

    return (
        <box
            onDestroy={() => {
                myVar.drop();
                derived.drop();
            }}
        />
    );
}
```
```


This Markdown file provides an overview of the `Variable` object in Astal, including its creation, subscription, composition, subprocess management, GObject connections, and proper disposal. For more detailed information, refer to the [Astal documentation](https://aylur.github.io/astal/guide/typescript/variable#variable-composition). 
