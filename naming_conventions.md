<strong>Open DICOM<em>web</em> Project </strong>

# Naming Conventions

## Checking Value Validity using VR

This is the most basic way of validating an Element's value. In the following signatures '<VR>' denotes the static Type of the VR.

```bool <VR>.isValidValue<V>(V value, [Issues issues])```

```V <VR>.checkValue(V value, [Issues issues])```

```Issues <VR>.issues(V value, [Issues issues])```

## Checking Value Validity using Tag

```bool tag.isValidValue<V>(V value, [Issues issues])```

```V tag.checkValue(V value, [Issues issues])```

```Issues tag.issues(V value, [Issues issues])```

## Checking Value Validity using Element Type <E>

```bool <E>.isValidValue<V>(V value, [Issues issues])```

```V <E>.checkValue(V value, [Issues issues])```

```Issues <E>.issues(V value, [Issues issues])```

## Checking Value Validity using Element

```bool element.isValidValue<V>(V value, [Issues issues])```

```V element.checkValue(V value, [Issues issues])```

```Issues element.issues(V value, [Issues issues])```

/// Naming
///   bool isSomething(x)
///   bool inRange(T v, T min, T max)
///   T checkSomething(T x, {onError: (T x) => T) - returns x or throws if invalid.
///   List<String> testSomething(T x) - returns a list of errors or null
///   X parse(String s, {onError = f}
