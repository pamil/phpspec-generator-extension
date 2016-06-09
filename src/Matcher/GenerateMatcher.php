<?php

namespace Pamil\PhpSpecGeneratorExtension\Matcher;

use PhpSpec\Exception\Example\FailureException;
use PhpSpec\Formatter\Presenter\Presenter;
use PhpSpec\Matcher\MatcherInterface;

/**
 * @author Kamil Kokot <kamil@kokot.me>
 */
final class GenerateMatcher implements MatcherInterface
{
    /**
     * @var Presenter
     */
    private $presenter;

    /**
     * @param Presenter $presenter
     */
    public function __construct(Presenter $presenter)
    {
        $this->presenter = $presenter;
    }

    /**
     * {@inheritdoc}
     */
    public function supports($name, $subject, array $arguments)
    {
        return 'generate' === $name;
    }

    /**
     * {@inheritdoc}
     */
    public function positiveMatch($name, $subject, array $arguments)
    {
        if (!$subject instanceof \Generator) {
            throw new FailureException('Subject should be an instance of \Generator.');
        }

        $toGenerate = count($arguments);
        $generated = 0;
        foreach ($arguments as $argument) {
            list($expectedKey, $expectedValue) = $this->castArgumentToKeyValueTuple($argument);

            if (!$subject->valid()) {
                throw new FailureException(sprintf(
                    'Expected %d elements, but only %d was generated.',
                    $toGenerate,
                    $generated
                ));
            }

            $actualKey = $subject->key();
            $actualValue = $subject->current();
            if ($expectedKey !== $actualKey || $expectedValue !== $actualValue) {
                throw new FailureException(sprintf(
                    'Element #%d was expected to have key %s with value %s, but key %s with value %s was given.',
                    $generated,
                    $this->presenter->presentValue($expectedKey),
                    $this->presenter->presentValue($expectedValue),
                    $this->presenter->presentValue($actualKey),
                    $this->presenter->presentValue($actualValue)
                ));
            }

            $subject->next();
            ++$generated;
        }
    }

    /**
     * {@inheritdoc}
     */
    public function negativeMatch($name, $subject, array $arguments)
    {
        try {
            $this->positiveMatch($name, $subject, $arguments);
        } catch (FailureException $exception) {
            return;
        }

        throw new FailureException('Generated elements are the same as not expected elements.');
    }

    /**
     * {@inheritdoc}
     */
    public function getPriority()
    {
        return 100;
    }

    /**
     * @param array $argument
     *
     * @return array
     *
     * @throws FailureException
     */
    private function castArgumentToKeyValueTuple(array $argument)
    {
        switch (count($argument)) {
            case 1:
                return [key($argument), current($argument)];
            case 2:
                return $argument;
        }

        throw new FailureException(sprintf(
            'Cannot match against %s expected argument.',
            $this->presenter->presentValue($argument)
        ));
    }
}
