<?php

namespace Pamil\PhpSpecGeneratorExtension\Matcher;

use PhpSpec\Exception\Example\FailureException;
use PhpSpec\Formatter\Presenter\Presenter;
use PhpSpec\Matcher\MatcherInterface;

/**
 * @author Kamil Kokot <kamil@kokot.me>
 */
final class GenerateKeysMatcher implements MatcherInterface
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
        return 'generateKeys' === $name;
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
        foreach ($arguments as $expected) {
            if (!$subject->valid()) {
                throw new FailureException(sprintf(
                    'Expected %d elements, but only %d was generated.',
                    $toGenerate,
                    $generated
                ));
            }

            $actual = $subject->key();
            if ($expected !== $actual) {
                throw new FailureException(sprintf(
                    'Element #%d was expected to have key %s, but %s was given.',
                    $generated,
                    $this->presenter->presentValue($expected),
                    $this->presenter->presentValue($actual)
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

        throw new FailureException('Generated keys are the same as not expected keys.');
    }

    /**
     * {@inheritdoc}
     */
    public function getPriority()
    {
        return 100;
    }
}
